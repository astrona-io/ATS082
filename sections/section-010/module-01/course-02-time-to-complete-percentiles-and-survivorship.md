---
draft: true
exam_objectives:
  - Platform Efficiency and Team Productivity
---
# Time To Complete, Percentiles And Survivorship

The completion rate says how often users reach a usable environment. It does not say how long they wait. Time is the second half of an efficiency report, and it is easy to report badly. This part shows why a mean hides the experience of the slow requests, how percentiles describe a distribution, and how leaving out failed requests makes a service look better than it is.

## Why one average is not enough

A **distribution** is the full set of values of a measure, for example all the times to complete. A single average squeezes the distribution into one number, and different distributions can give the same average. A service where every request takes two minutes and a service where most requests take one minute and a few take twenty minutes can have the same mean. Users of the second service wait very differently, and the mean cannot show it.

The mean also reacts strongly to a few extreme values. In the example data, 12 requests completed. Eleven of them took between 60 and 110 seconds, and one large request took 600 seconds. That single request raises the mean to 125 seconds, although most users waited about 80 seconds.

## Median and percentiles

A **percentile** is a value below which a given share of the observations fall. The 50th percentile is the **median**: half of the requests finish at or below it. The 90th percentile, written p90, is the time that 90 percent of requests meet. Percentiles are not changed much by one extreme value, and they answer questions that users ask, such as "how long will it usually take" and "how long can it take on a bad day".

This course uses the **nearest-rank method**, which is simple and gives one of the observed values. Sort the values from smallest to largest. For a percentile `p` between 0 and 1 and `n` values, the result is the value at position `ceil(p x n)`, counting from 1. The function `ceil` rounds up to the next whole number. With 12 completed requests, the median is at position `ceil(0.5 x 12)`, which is 6, and p90 is at position `ceil(0.9 x 12)`, which is `ceil(10.8)`, so 11.

Other methods interpolate between two values and can give a slightly different answer. The method must be stated in a report, because two people who use different methods get different numbers from the same data.

## Computing percentiles with jq

<!-- astrona:playground:renew -->

The commands below use the file `requests.json` from the same data set of 20 requests. If you do not have the file yet, create it:

```sh
kubectl -n metrics get configmap provisioning-requests -o json | jq -r '.data["requests.json"]' > requests.json
```

First look at the completed times in sorted order. `select` keeps completed requests, `.seconds` takes the value and `sort` orders it:

```sh
jq -c '[.[] | select(.outcome == "completed") | .seconds] | sort' requests.json
```

The output is `[60,65,70,70,75,80,85,90,95,100,110,600]`. The sixth value is 80 and the eleventh is 110. The last value, 600, is the one that pulls the mean up.

A shell function gives the calculation a name, so that you run the same logic each time. Save this as `percentiles.sh`. The optional second argument limits the calculation to one request class:

```sh
pctl_completed() {
  jq --argjson p "$1" --arg class "${2:-}" '[.[] | select(.outcome == "completed" and ($class == "" or .class == $class)) | .seconds] | sort | .[((length * $p) | ceil) - 1]' requests.json
}
```

Load it into the current shell:

```sh
source percentiles.sh
```

Now ask for the median and p90 of all completed requests:

```sh
pctl_completed 0.5
pctl_completed 0.9
```

The answers are `80` and `110`. The report can now say: half of the completed requests finish within 80 seconds and 90 percent within 110 seconds. The mean of 125 seconds is higher than the p90, which shows how much one slow request distorts it.

## Survivorship: what the completed-only view leaves out

**Survivorship bias** is the error of describing a group by looking only at the members that passed a filter. A time-to-complete figure that uses completed requests only is exactly this case. The requests that did not complete are the ones with the worst experience, and the figure ignores them.

Look at how long users waited before the failed and abandoned requests ended:

```sh
jq -c '[.[] | select(.outcome == "abandoned") | .seconds] | sort' requests.json
jq -c '[.[] | select(.outcome == "failed") | .seconds] | sort' requests.json
```

The abandoned requests ran for 900, 1200 and 1500 seconds before the user gave up. The failed requests ended after 30 to 60 seconds. The longest waits in the whole data set belong to requests that never produced an environment. A report with a median of 80 seconds does not contain them. It must be shown next to the completion rate of 60 percent, and the abandoned waits should be named as a separate finding.

Do not mix the two kinds of time in one number. The time of a failed request is the time until the error, and the time of an abandoned request is the time until the user stopped waiting. Neither is a time to complete. A mean over all 20 requests is 267 seconds, and it is not a time to complete anything.

## Breaking the result down by class

An aggregate over very different request classes can hide where users meet the most friction. The data has two classes: `small` and `large`. Compute p90 for each class of completed requests:

```sh
pctl_completed 0.9 small
pctl_completed 0.9 large
```

The p90 of `small` is `95` and the p90 of `large` is `600`. The overall p90 of 110 is close to the small class because there are 10 small completed requests and only 2 large ones. Now compute the completion rate of each class:

```sh
jq -c 'group_by(.class) | map({class: .[0].class, attempts: length, completed: ([.[] | select(.outcome == "completed")] | length)})' requests.json
```

The output is `[{"class":"large","attempts":8,"completed":2},{"class":"small","attempts":12,"completed":10}]`. The class `large` completes 2 of 8 attempts, which is 25 percent. The class `small` completes 10 of 12. The overall figures describe a platform where `large` requests are the problem, and only the breakdown shows it.

Each breakdown has a cost: a class with few attempts gives a percentile that rests on very few values. The `large` class has only 2 completed requests, so its p90 is simply its slower value. A team must state the count next to every percentile and treat small groups as a reason to collect more data, not as proof.

## What you know now

A time-to-complete report needs the median and a high percentile, a stated method and the counts behind them. It must sit next to the completion rate and the waits of failed and abandoned attempts, because the completed-only view leaves out the worst experiences. A breakdown by class shows where the friction is. The open question is what users say about this friction, and how to combine counts with what they tell the team.

## Common pitfalls

> [!WARNING]
> Do not report a mean of completed requests as the time to complete. Do not mix the time of failed or abandoned requests into a completion time. Do not name a percentile without the method and the number of values it comes from.
