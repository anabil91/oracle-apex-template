# ai_generate

Deployable SQL/PL-SQL prepared by an AI tool for a human to review and run, in `YYYY-MM-DD/` subfolders.

- Tracked in git, so it goes through PR review like any other change.
- Not a deployment path: real changes must also exist under `database/` with a changeset (see `.agents/workflows/database-change.md`).
- Use this for anything an agent may not run itself (for example on `test` or `prod`).
- Start scripts with `SET DEFINE OFF`. Use UTF-8.
