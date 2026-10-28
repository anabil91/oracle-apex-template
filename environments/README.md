# Environments

Only **templates** live here. Real `*.env` files are git-ignored; in CI the same variables come from the secret store.

| Env | Purpose | Deployed by |
|---|---|---|
| `dev` | Shared APEX development workspace | developers (APEX Builder) and `deploy.sh dev` |
| `ci` | Ephemeral container per PR (only once CI exists) | PR pipeline |
| `test` | QA / UAT | team lead with `scripts/deploy/deploy.sh test` |
| `demo` | Demonstrations to stakeholders | team lead, from a tagged release |
| `prod` | Production | architecture team, from a tagged release, after approval |

## Settings (`<env>.env`)

Read as plain `KEY=VALUE` data by `scripts/lib/sqlcl.sh`. The file is never executed.

| Key | Meaning |
|---|---|
| `SQLCL_CONNECTION` | Saved SQLcl connection name. Preferred: the password stays in SQLcl's store. Create once with `conn -save <name> -savepwd <user>@<host>:<port>/<service>`. |
| `DB_CONNECT` | `host:port/service`. Used only when `SQLCL_CONNECTION` is empty. |
| `DB_PASSWORD` | Only with `DB_CONNECT`. Leave empty to be prompted. |
| `DB_USER` | Expected session user. Every script stops if the connection logs in as someone else. |
| `APEX_WORKSPACE` | Target APEX workspace. |
| `APEX_SCHEMA` | Parsing schema the apps are imported with. |
| `APEX_APPS` | `<app id>:<folder>` pairs, comma separated, e.g. `100:ux-pattern-catalog,200:hr-portal`. The folder under `apex/apps/` is the app alias in lowercase. |
