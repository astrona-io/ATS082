# Contributing

Read CLAUDE.md before editing. Its shared prefix is copied from ATS015, while the custom portion describes ATS082: Certified Cloud Native Platform Engineering Associate (CNPA), Measuring your Platform (8%), part of ATP016.

Preserve IDs, weights and existing track registration. Develop self-contained explanations with mechanisms, examples, prerequisites and failure reasoning. Start each section with an introduction and end each module with its own Summary. Keep technical Markdown draft until review.

On 2026-11-03 the maintainer lifted the reading-only rule: modules have playgrounds and graded labs, and sections have capstone labs and quizzes. Labs are built untested; do not claim executed results until a lab has run. Quizzes are `quiz.yaml` question banks listed in astrona.yaml; preserve stable identities and per-option feedback.

Use primary sources in SOURCES.md and record adaptation paths in AUTHORING.yaml. Run `astrona validate -c` on every lab and playground, `bash -n` on every script and `ruby -ryaml` on every YAML file when changing structure. Review Markdown and questions for semantic correctness as well as structure.
