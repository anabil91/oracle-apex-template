# Automated code review

The reviewer runs on every PR and posts inline comments.

- **Rules**: [`/AGENTS.md`](../../AGENTS.md) (blocking vs warning) — single source of truth.
- **Scope**: only the PR diff. For APEX changes, it reviews the APEXlang `.apx` files under `apex/apps/<alias>/`.
- **Inputs it also receives**: lint report + test/coverage results from earlier stages, so it can flag untested changes.
- **Gate**: the check fails when any `[BLOCKING]` finding is reported. Warnings are informational.

Planned files here:
- `review-paths.txt`: include/exclude globs for the reviewer
- `review-prompt.md`: the extra task instructions (if the reviewer needs more than `AGENTS.md`)
