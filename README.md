# Oracle APEX Project Repository

Source-controlled home for our Oracle APEX application(s), database objects,
utPLSQL tests, and CI/CD tooling. Designed for **many developers working in
parallel**, with **automated build, test, and code review** on every pull request.

---

## Repository layout

```
oracle-apex-template/
├── apex/                         # APEX application exports (split, readable)
│   ├── apps/
│   │   └── f100/                 # One folder per application ID
│   ├── plugins/                  # Shared plug-ins (exported separately)
│   └── static_files/             # Workspace/app static files source (JS, CSS, images)
│       ├── js/
│       └── css/
│
├── database/
│   ├── schemas/
│   │   └── app_owner/            # One folder per schema; object-type subfolders
│   │       ├── tables/           #   DDL reference (deployed via changelog)
│   │       ├── sequences/
│   │       ├── indexes/
│   │       ├── constraints/
│   │       ├── views/            #   repeatable (CREATE OR REPLACE)
│   │       ├── materialized_views/
│   │       ├── types/
│   │       ├── packages/         #   .pks (spec) / .pkb (body) - repeatable
│   │       ├── procedures/
│   │       ├── functions/
│   │       ├── triggers/
│   │       ├── synonyms/
│   │       ├── grants/
│   │       └── jobs/
│   ├── changelog/                # Liquibase (SQLcl `lb`) - the deploy order
│   │   ├── master.xml            #   entry point
│   │   ├── releases/             #   versioned, run-once changes (DDL/DML)
│   │   └── repeatable.xml        #   run-on-change code (packages, views...)
│   └── data/
│       ├── reference/            # Lookup/seed data (all environments)
│       └── test/                 # Test data (non-prod only)
│
├── tests/
│   └── utplsql/
│       ├── app_owner/            # Test packages mirror schema folders
│       └── run_tests.sql         # Runs all suites (used by CI)
│
├── scripts/                      # Build/deploy/export scripts (CI calls these)
│   ├── build/
│   ├── deploy/
│   ├── export/
│   └── test/
│
├── ci/                           # Pipeline definitions & lint/review config
│   ├── lint/
│   └── review/
│
├── environments/                 # Per-env config templates (NO secrets)
├── docs/                         # Standards, workflow, ADRs
│   └── adr/
│
├── .github/                      # PR template, CODEOWNERS, workflows
├── CLAUDE.md                     # Conventions & rules for the automated AI reviewer
├── CONTRIBUTING.md               # Developer workflow (read this first)
├── .editorconfig  .gitattributes  .gitignore
```

## Key design decisions

| Decision | Why | Details |
|---|---|---|
| **APEX exported as split + readable YAML, original IDs** | Per-page files mean small diffs and few merge conflicts; YAML is easy to review | [apex/README.md](apex/README.md) |
| **One file per DB object, organized by schema → type** | Clear ownership, easy diffs, predictable paths for tooling | [database/README.md](database/README.md) |
| **Liquibase via SQLcl for deployment order** | Tracks what ran where; ships with SQLcl, so there's nothing extra to install | [database/changelog/](database/changelog/) |
| **Versioned vs. repeatable changes** | Tables evolve with run-once changesets; code (packages/views) is re-deployed whenever it changes | [docs/adr/0002-deployment-model.md](docs/adr/0002-deployment-model.md) |
| **utPLSQL tests mirror source layout** | `packages/customer_api.pkb` → `tests/utplsql/app_owner/test_customer_api.pkb` | [tests/README.md](tests/README.md) |
| **Thin pipelines, logic in `scripts/`** | The same scripts run locally and in CI; the CI vendor can be swapped | [ci/README.md](ci/README.md) |
| **Trunk-based with short-lived feature branches** | Fewer long-lived conflicts in APEX metadata | [docs/branching-and-release.md](docs/branching-and-release.md) |

## Quick start (developer)

1. Install **SQLcl** (≥ 24.x), **Git**, and **VS Code** with the *Oracle SQL Developer Extension*.
2. Copy `environments/dev.env.example` → `environments/dev.env` and fill in your connection (it's git-ignored).
3. Read [CONTRIBUTING.md](CONTRIBUTING.md). It covers branching, exporting APEX, and opening a PR.

## Pipeline overview (to be implemented)

```
PR opened ─► Lint (PL/SQL Cop) ─► Deploy to ephemeral DB ─► utPLSQL + coverage ─► Automated review ─► Human review ─► Merge
Merge to main ─► Build artifact ─► Deploy TEST ─► (approval) ─► Deploy PROD
```
