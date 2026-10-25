# CI/CD design

## Pull request pipeline (must pass before merge)

| # | Stage | Tooling | Fails the PR when |
|---|---|---|---|
| 1 | **Static checks** | changelog XML validation, secret scan (gitleaks), "edited released changeset" check | invalid XML, secrets found, a merged changeset was modified |
| 2 | **PL/SQL lint** | dbLinter / Trivadis PL/SQL Cop with `ci/lint/` rules (Trivadis PL/SQL & SQL Coding Guidelines) | any rule configured as an error |
| 3 | **Ephemeral DB** | Oracle Database Free container (`gvenzl/oracle-free`), with APEX installed or a prebuilt image containing APEX | — |
| 4 | **Deploy** | `scripts/deploy/deploy.sh ci`: Liquibase update, compile, APEX install | deploy error or invalid objects |
| 5 | **Unit tests** | utPLSQL v3 + utPLSQL-cli | any failing test; coverage on changed code < 80% |
| 6 | **Automated review** | AI reviewer driven by `CLAUDE.md` rules + `ci/review/` config, posting inline PR comments | any `[BLOCKING]` finding (configurable) |
| 7 | **Human review** | CODEOWNERS + branch protection | — |

Each stage publishes artifacts: lint report, JUnit, Cobertura, review summary.

## Main / release pipeline

```
merge to main ─► build dist/<version>.zip ─► deploy DEV/TEST (auto) ─► smoke tests
tag vX.Y.Z    ─► deploy PROD (manual approval, same artifact)
```

- **Build once, deploy many**: PROD gets the exact artifact that was tested.
- Environment secrets are stored in the CI secret store and exposed as env vars matching `environments/*.env.example`.
- Every environment runs `lb update`; Liquibase skips changesets that already ran.

## Branch protection on `main`
- Require PR, ≥ 1 approval, CODEOWNERS review
- Require status checks: `lint`, `deploy`, `test`, `review`
- Require linear history (squash merge)
- Dismiss stale approvals when new commits are pushed
