# Environments

Only **templates** live here. Real `*.env` files are git-ignored; in CI the same variables come from the secret store.

| Env | Purpose | Deployed by |
|---|---|---|
| `dev` | Shared APEX development workspace | developers (APEX Builder) and `deploy.sh dev` |
| `ci` | Ephemeral container per PR (only once CI exists) | PR pipeline |
| `test` | QA / UAT | a developer or team lead with `scripts/deploy/deploy.sh test` (CI later) |
| `demo` | Demonstrations to stakeholders | release owner, from a tagged release |
| `prod` | Production | release owner, from a tagged release, after approval |

APEX workspace name, app ID, and app-specific settings per environment are set at install time from these variables.
