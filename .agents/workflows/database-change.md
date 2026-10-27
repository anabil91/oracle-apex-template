# Workflow: make a database change

Follow `CONTRIBUTING.md` section 3.

| Change | Do |
|---|---|
| Table, column, index, constraint, sequence | Update the DDL in `database/schemas/<schema>/<type>/` and add a changeset in `database/changelog/releases/<version>/` with a `<rollback>`. Changeset id `<ticket>-<n>`. |
| Package, view, function, procedure, trigger | Edit the file in `database/schemas/<schema>/<type>/` and register new objects in `database/changelog/repeatable.xml`. |
| Reference data | `database/data/reference/` plus a changeset. |

1. Never edit a changeset already on `main`.
2. Destructive DDL (`DROP TABLE`, `DROP COLUMN`, `TRUNCATE`) needs a rollback strategy in the PR description. Ask the user first.
3. Need to try SQL against a database? Write it to `ai_generate/YYYY-MM-DD/` and follow `.agents/rules/agent-safety.md`.
4. Add or update utPLSQL tests (`write-and-run-unit-tests.md`).
