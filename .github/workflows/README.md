# Workflows (to be added)

Planned workflow files. Each stays thin and calls the scripts in `/scripts`:

| File | Trigger | Steps |
|---|---|---|
| `pr-validate.yml` | pull_request | lint → spin up Oracle Free container → install utPLSQL → `scripts/deploy` → `scripts/test` → publish JUnit + coverage |
| `pr-review.yml` | pull_request | automated code review using `AGENTS.md` rules and `ci/review/` config; posts inline comments |
| `deploy.yml` | push to `main` / tag `v*` | build artifact → deploy TEST → manual approval → deploy PROD |

See [ci/README.md](../../ci/README.md) for the stage details.
