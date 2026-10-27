# Contributing

## 1. Branching

- `main` is always deployable. It is protected: changes go in only through a PR, CI must be green, and at least one approval is required.
- Create a short-lived branch per work item: `feature/<ticket>-short-desc`, `fix/<ticket>-short-desc`, `hotfix/<ticket>-...`
- Keep branches small and merge within days, not weeks. APEX metadata conflicts grow with branch age.

See [docs/branching-and-release.md](docs/branching-and-release.md).

## 2. Working on APEX with multiple developers

APEX stores the app in the database, not in files, so we need discipline:

1. **Lock the pages** you're editing (Page Designer → lock icon) so others can't overwrite them.
2. For larger changes, use an **APEX Working Copy** (APEX 24.1+) and merge it back when done.
3. When finished, **export** the app into the repo:
   ```
   sql /nolog @scripts/export/export_apex.sql 100
   ```
   (Or by hand: `apex export -applicationid 100 -split -exptype APPLICATION_SOURCE,READABLE_YAML -expOriginalIds -skipExportDate`.)
4. **Commit only the files related to your change.** If the export shows changes to pages you didn't touch, someone else's work is in the shared DEV workspace. Don't commit those files. Discard them with `git restore <file>`.
5. Unlock your pages after the PR is merged.

## 3. Database changes

| Change type | Where the source goes | How it's deployed |
|---|---|---|
| New/altered table, column, index, constraint, sequence | `database/schemas/<schema>/<type>/` (keep the full current DDL as reference) **and** a changeset in `database/changelog/releases/<version>/` | Versioned, runs once |
| Package, view, function, procedure, trigger, type body | `database/schemas/<schema>/<type>/` | Repeatable, re-runs whenever the file changes (already listed in `repeatable.xml`; add new objects there) |
| Reference data | `database/data/reference/` + changeset | Versioned, or `runOnChange` for MERGE scripts |

Rules:
- **Never edit a changeset that has already been merged.** Add a new one instead.
- Changeset id format: `<ticket>-<n>` and author = your Git username.
- Every DDL changeset must have a `<rollback>` where one is possible.

## 4. Tests (utPLSQL)

- Every new or changed public package procedure/function needs tests in `tests/utplsql/<schema>/test_<package>.pks/.pkb`.
- Run them locally before you push: `sql user/pass@db @tests/utplsql/run_tests.sql`
- Target: ≥ 80% line coverage on changed code (enforced by CI later).

## 5. Pull requests

- Fill in the PR template checklist.
- CI runs lint → deploy → tests → automated review. Fix everything the automated review flags as **blocking** before you ask for human review.
- CODEOWNERS automatically requests reviewers for the areas you touched.

## 6. Coding standards

See [docs/coding-standards.md](docs/coding-standards.md). The automated reviewer enforces them.

## 7. Working with AI coding tools

The repo works with Claude Code, Gemini and Antigravity (use whichever your company allows).

- All conventions live in [AGENTS.md](AGENTS.md). `CLAUDE.md` and `GEMINI.md` only import it, so edit `AGENTS.md`.
- Shared rules, workflows and `uc-apx` skills live in `.agents/`. Don't add tool-specific copies.
- Agents are read-only on `test` and `prod`. Anything they want deployed goes to `ai_generate/YYYY-MM-DD/` and goes through PR review.
- AI-written code follows the same rules as yours: tests, changeset with rollback, no secrets.
- Refresh the skills after upgrading SQLcl: `uc-apx skills sync --agent universal`.
