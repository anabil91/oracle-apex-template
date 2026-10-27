# Agent safety rules

Apply to every AI tool working in this repo. `environments/README.md` defines the environments
(`dev`, `ci`, `test`, `prod`).

## Database and SQLcl
- Connect only through an exact, user-named saved SQLcl connection. Never guess or fall back to another one.
- Before running SQL, verify with a read-only query: database/service, session user, current schema.
- `test` and `prod` are read-only for agents: `SELECT` only. No DML, DDL or `COMMIT`.
  Prepare the change under `ai_generate/YYYY-MM-DD/` for a human to deploy.
- If a connection name could be production and you are unsure, stop and ask.
- `dev`: ask for approval right before `COMMIT`, bulk DML, destructive DDL (`DROP`, `TRUNCATE`) or irreversible migrations,
  unless the user named that exact operation and target.
- Preview affected rows and dependencies before DML/DDL.
- Inspect a script before running it. Stop if it contains an unexpected `CONNECT`.
- Use `SET DEFINE OFF` when running source code that contains `&`.
- Never run `scripts/deploy/deploy.sh` against `test`, `demo` or `prod`. `--preview` on `dev` is fine.
- Do not use a `SYS`/`SYSDBA` connection for project work.

## Repository
- Change the database only through source files in `database/` plus a Liquibase changeset, never by hand in a shared DB without a matching file.
- Never edit a changeset that already exists on `main`. Add a new one.
- APEX: change `apex/` only via export or the `uc-apx` skills, and keep the diff limited to the pages in scope.
- Run `uc-apx validate` after any `.apx` edit.

## Secrets and external effects
- Never write or print passwords, tokens, wallets or connection strings with credentials. Do not dump environment variables.
- Real `environments/*.env` files stay git-ignored. Only `*.env.example` is committed.
- Confirm URL, method and payload before any call to an external service.

## Git
- Check `git status` first and keep unrelated changes untouched.
- Work on a branch, never directly on `main`.
- Stage only intended files. Commit or push only when the user asks.

## Learning
- Add a lesson to `docs/agent-lessons.md` only if it has Trigger, Evidence, Preferred behavior and Verification. No secrets, no task status.
