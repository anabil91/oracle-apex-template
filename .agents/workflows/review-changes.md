# Workflow: review changes (human-run or automated)

Use before opening a PR, or when asked to review a diff. Any AI tool can run this.

1. Get the diff against `main`: `git diff main...HEAD`. Review only what changed.
2. Apply the rules in `AGENTS.md` ("Review rules: BLOCKING" and "WARNING"). Naming follows `docs/coding-standards.md`.
3. For APEX changes review `apex/apps/*/readable/**` (YAML) and ignore the generated `.sql` duplicates.
4. Check tests: every changed public routine in `packages/*.pkb` needs a change under `tests/utplsql/`.
5. Check the PR checklist in `.github/pull_request_template.md` (changeset + rollback, `repeatable.xml` registration, no secrets).
6. Output per the "Review output format" in `AGENTS.md`: grouped by file, `[BLOCKING]` / `[WARNING]`, `file:line`, reason, suggested fix, one-line verdict.
7. Do not invent findings. If nothing is wrong, say so.
