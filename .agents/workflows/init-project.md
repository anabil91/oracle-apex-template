---
description: Set up a new clone or a new project from this template, step by step with the user
---

# Workflow: initialize a project

Run with the user. Ask before installing anything or writing outside the repo.

1. Run `scripts/check_setup.sh dev`. Fix each `MISS` with the user, one at a time.
2. **Saved connection** (keeps passwords out of files). Ask the user to run this in SQLcl themselves, never type their password for them:
   `conn -save <name> -savepwd <user>@<host>:<port>/<service>`
3. Copy `environments/dev.env.example` to `environments/dev.env`. Fill in `SQLCL_CONNECTION`, `DB_USER`, `APEX_WORKSPACE`, `APEX_SCHEMA`, `APEX_APPS`.
   Find app ids and aliases with `apex list` in SQLcl. The folder is the alias in lowercase.
4. New project only: rename `database/schemas/app_owner/` to the real schema (lowercase) in one commit, replacing `app_owner` everywhere (changelogs, `tests/utplsql/`, docs). Add one folder per schema.
5. Fill in the "Schemas and apps" table in `AGENTS.md`.
6. Export the apps: `scripts/export/export_apex.sh dev`. Commit them on a branch.
7. Existing database objects: baseline them before the first `lb update` (generate the files with `lb generate-schema`, then mark what already exists as run with `lb changelog-sync`). Do this with the user and a DBA, never on test, demo or prod without approval.
8. Check: `scripts/deploy/deploy.sh dev --preview` shows only changes you expect.
