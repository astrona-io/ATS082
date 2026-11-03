#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

data="$(kubectl -n metrics get configmap team-adoption -o json | jq -r '.data["teams.json"]')"
eligible_teams="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.eligible)]|length')"
adopted_teams="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.eligible and .onboarded)]|length')"
adoption_rate_percent="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; ([.[]|select(.eligible and .onboarded)]|length) * 100 / ([.[]|select(.eligible)]|length)')"
mandated_adopted_teams="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.onboarded and .mandated)]|length')"
voluntary_adopted_teams="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.onboarded and (.mandated|not))]|length')"
median_days_to_first_deploy="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.onboarded)|.days_to_first_deploy]|med')"
p90_days_to_first_deploy="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.onboarded)|.days_to_first_deploy]|pctl(0.9)')"
self_service_rate_percent="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; ([.[].self_service_requests]|add) * 100 / (([.[].self_service_requests]|add) + ([.[].manual_tickets]|add))')"
csat_satisfied_percent="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.csat != null)] | (([.[]|select(.csat >= 4)]|length) * 100 / length)')"
nps="$(echo "$data" | jq -r 'def med: sort | (length) as $n | if $n == 0 then null elif ($n % 2) == 1 then .[($n-1)/2] else (.[$n/2-1] + .[$n/2]) / 2 end; def pctl($p): sort | .[((length * $p) | ceil) - 1]; [.[]|select(.nps != null)] | ((([.[]|select(.nps >= 9)]|length) - ([.[]|select(.nps <= 6)]|length)) * 100 / length)')"
kubectl -n metrics create configmap adoption-report \
  --from-literal=eligible-teams="$eligible_teams" \
  --from-literal=adopted-teams="$adopted_teams" \
  --from-literal=adoption-rate-percent="$adoption_rate_percent" \
  --from-literal=mandated-adopted-teams="$mandated_adopted_teams" \
  --from-literal=voluntary-adopted-teams="$voluntary_adopted_teams" \
  --from-literal=median-days-to-first-deploy="$median_days_to_first_deploy" \
  --from-literal=p90-days-to-first-deploy="$p90_days_to_first_deploy" \
  --from-literal=self-service-rate-percent="$self_service_rate_percent" \
  --from-literal=csat-satisfied-percent="$csat_satisfied_percent" \
  --from-literal=nps="$nps" \
  --dry-run=client -o yaml | kubectl apply -f -
echo "[solution] Applied."
