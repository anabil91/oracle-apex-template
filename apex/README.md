# APEX applications

## Format: APEXlang (`.apx`)

Apps are stored as **APEXlang**, one readable file per page and shared component. It needs APEX 26.1+ and SQLcl 26.1+.
The same files are what reviewers read, what the `uc-apx` skills edit, and what `deploy.sh` imports.

```
apex/
├── apps/
│   └── <app-alias>/              # one folder per app, named after the app alias (lowercase)
│       ├── .apex/apexlang.json   #   format version
│       ├── application.apx
│       ├── pages/p00001-home.apx ...
│       ├── shared-components/...
│       ├── supporting-objects/...
│       └── deployments/          #   git-ignored: per-environment settings incl. the checksum salt
├── plugins/                      # Plug-ins shared across apps (exported individually)
└── static_files/                 # SOURCE for JS/CSS
```

Which app lives in which folder is set per environment in `APEX_APPS` (`environments/<env>.env`), for example `100:ux-pattern-catalog`.

## Two ways to change an app

Both end the same way: reviewed `.apx` files in a PR.

**Builder first** (Page Designer on DEV):
1. Lock your pages, make the change in Page Designer.
2. `scripts/export/export_apex.sh dev` (or `... dev 100` for one app). It refuses to run over uncommitted changes in the app folder.
3. `git diff -- apex/apps`, commit only your pages, `git restore` the rest.

**File first** (you or an AI agent edit `.apx`):
1. Edit with the `uc-apx` skills in `.agents/skills/` (`create-page`, `add-region-or-item-to-page`, ...).
2. `uc-apx validate --app-dir apex/apps/<alias>`.
3. `scripts/deploy/deploy.sh dev --preview` runs the official `apex validate` too.
4. `scripts/deploy/deploy.sh dev` imports it into DEV. Check it in the browser, then commit.

Don't mix both on the same pages at the same time: an export overwrites file edits that were not imported.

## Installing into an environment

`scripts/deploy/deploy.sh <env>` imports every app in `APEX_APPS` after the database changes:

```sql
apex import -input apex/apps/<alias> -workspace <APEX_WORKSPACE> -id <app id> -schema <APEX_SCHEMA>
```

## Rules
- Keep PL/SQL inside APEX to **one line calling a package** (`customer_api.create_customer(...)`). Logic lives in `database/` where it can be unit-tested and reviewed.
- Keep JavaScript and CSS in `static_files/`, not inline on pages.
- Never hard-code environment URLs or credentials. Use Application Settings / Web Credentials / Substitution strings set at deploy time.
- Never commit `deployments/`.
