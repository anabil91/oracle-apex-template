# Environments

Only **templates** live here. Real `*.env` files are git-ignored; in CI the same variables come from the secret store.

| Env | Purpose | Deployed by |
|---|---|---|
| `dev` | Shared APEX development workspace | developers (APEX Builder) + CI on merge |
| `ci` | Ephemeral container per PR | PR pipeline |
| `test` | QA / UAT | main pipeline (auto) |
| `prod` | Production | release pipeline (manual approval) |

APEX workspace name, app ID, and app-specific settings per environment are set at install time from these variables.
