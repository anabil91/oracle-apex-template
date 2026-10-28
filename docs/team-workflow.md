# Team workflow (no CI yet)

For every developer. Read [CONTRIBUTING.md](../CONTRIBUTING.md) for the details of each step.

## The idea in one minute

- **One shared line of code: `main`.** It always holds everything that is ready.
- **Servers are not branches.** Dev, Test, Demo and Prod each run some version of `main`. Which version is tracked by Liquibase in each database, not by a branch.
- **You never write a release script.** Every database change is a small changeset file in the repo. `deploy.sh` applies the ones an environment has not seen yet.

```
your branch ──PR──► main ──► deploy dev ──► deploy test ──► (tag vX.Y.Z) ──► deploy demo ──► deploy prod
```

## Daily flow

1. `git checkout main && git pull`, then `git checkout -b feature/<ticket>-short-name`.
2. Do the work. For the database, edit the object file under `database/schemas/` and add a changeset with a rollback. For APEX, lock your pages and export (`.agents/workflows/apex-export-and-edit.md`).
3. Add or update utPLSQL tests for any changed package routine.
4. Commit only files related to your ticket. Push the branch and open a PR using the template checklist.
5. A reviewer approves. Merge with **squash merge**. Delete the branch.
6. Deploy (below).

## Deploying without CI

Run from Git Bash in the repo root. Put the connection in `environments/<env>.env` (copy the `.example`; the real file is git-ignored). Leave the password empty to be prompted.

```bash
scripts/deploy/deploy.sh test --preview   # what is pending, plus the SQL, changes nothing
scripts/deploy/deploy.sh test             # asks you to type the environment name, then deploys
```

| Env | Who deploys | When |
|---|---|---|
| dev | any developer | after the PR is merged |
| test | developer or team lead | after dev looks fine |
| demo | release owner | from a tagged release |
| prod | release owner | from the same tagged release, after approval |

Always `git checkout main && git pull` first, so you deploy what was reviewed. Deploying a tag instead: `git checkout vX.Y.Z`.

APEX applications are still imported/exported with the APEX tools (`scripts/export/export_apex.sql`). `deploy.sh` covers database changes only.

## Why changes stop getting missed

- `deploy.sh <env> --preview` lists exactly which changesets that database has not run yet. Compare it to the PRs merged since the last deployment.
- Everything merged to `main` is deployed. You do not pick changes one by one.
- Never edit a changeset that was already merged. Add a new one. Liquibase would refuse the changed checksum anyway.

## Releases

1. Make sure `main` is deployed and checked on test.
2. Add the release folder `database/changelog/releases/<version>/` and list it in `release_index.xml` if it is new.
3. Tag it: `git tag vX.Y.Z && git push origin vX.Y.Z`.
4. Deploy that tag to demo, then prod.
5. Hotfix: branch `hotfix/<ticket>` from the prod tag, PR to `main`, tag a patch version.

## Using AI tools

Claude, Gemini and Antigravity all read `AGENTS.md`. Agents may not deploy to test, demo or prod. They prepare SQL under `ai_generate/` for you to review. See `.agents/rules/agent-safety.md`.

## Not automated yet

PR checks (lint, unit tests, AI review) and deployments need a CI system. See `ci/README.md` for the plan. Until then: run the utPLSQL tests yourself (`.agents/workflows/write-and-run-unit-tests.md`) and ask for a human review.
