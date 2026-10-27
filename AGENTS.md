# Repository guide for AI assistants and the automated reviewer

This is the single source of truth for every AI tool (Claude Code, Gemini, Antigravity, others)
and for the automated PR reviewer. `CLAUDE.md` and `GEMINI.md` only import this file, so edit
conventions here, never there. Keep it in sync with `docs/coding-standards.md`.

## Project facts
- Oracle Database 19c+/23ai, Oracle APEX 24.x, SQLcl for export/deploy, Liquibase (via SQLcl `lb`) for change tracking, utPLSQL v3 for tests.
- Main schema: `APP_OWNER`. APEX parsing schema: `APP_OWNER`.
- Layout: see README.md. Source: `database/schemas/<schema>/<object_type>/<object_name>.<ext>`.
- Many developers work in parallel: follow `CONTRIBUTING.md` (branch per work item, PR, CODEOWNERS review).

## Agent contract
Applies to every tool. Before non-trivial work read `.agents/rules/agent-safety.md`.
- `.agents/rules/`: always-on rules (database safety, secrets, git).
- `.agents/workflows/`: step-by-step procedures (unit tests, self-review, DB changes, APEX export).
- `.agents/skills/`: `uc-apx` skills for reading and editing apexlang (`.apx`) files. Refresh with `uc-apx skills sync --agent universal`.
- `ai_generate/YYYY-MM-DD/`: deployable SQL/PL/SQL an agent prepares for a human to review and deploy. Tracked in git.
- `scratch/`: git-ignored temp space for throwaway files and helper scripts.
- Never create a tool-specific copy of these rules. Add new rules under `.agents/`.

## Review rules: BLOCKING (must be fixed before merge)
1. **SQL injection**: dynamic SQL (`EXECUTE IMMEDIATE`, `DBMS_SQL`, `OPEN ... FOR <string>`) that concatenates user input. Require bind variables or `DBMS_ASSERT`.
2. **APEX XSS**: items/report columns with escaping disabled, or `htp.p` of unescaped user data. Require `apex_escape.html`.
3. **Edited released changeset**: changes to a changeset in `database/changelog/releases/` that already exists on `main`.
4. **Secrets**: passwords, wallets, tokens or connection strings with credentials in any file.
5. **Missing tests**: a new/changed public routine in `database/**/packages/*.pkb` with no matching change in `tests/utplsql/`.
6. **`WHEN OTHERS` without re-raise or logging**, or `WHEN OTHERS THEN NULL`.
7. **`COMMIT`/`ROLLBACK` inside API packages** called from APEX (transaction control belongs to the caller), unless the routine is documented as autonomous/batch.
8. **Destructive DDL** (`DROP TABLE`, `DROP COLUMN`, `TRUNCATE`) without a rollback strategy noted in the PR.

## Review rules: WARNING (comment, don't block)
- Business logic in APEX page processes/validations instead of a package (keep PL/SQL in APEX to a single API call).
- `SELECT *` in views/packages; implicit conversions; missing `%TYPE`/`%ROWTYPE`.
- Row-by-row processing where `FORALL`/`BULK COLLECT` or set-based SQL fits.
- Naming deviations from `docs/coding-standards.md`.
- APEX export noise: changes to pages unrelated to the PR description.
- Missing indexes on new foreign key columns.

## Review output format
Group findings by file. Prefix each with `[BLOCKING]` or `[WARNING]`, cite `file:line`, explain why, and suggest the fix. End with a one-line summary verdict.
