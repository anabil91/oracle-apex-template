# Branching & release

## Model: trunk-based with short-lived branches

```
main ──●────●────●────●────●──── (always deployable, tagged vX.Y.Z for PROD)
        \  /      \  /
     feature/APP-12  fix/APP-15
```

- Branch from `main` and merge back through a PR with **squash merge**.
- Aim for a branch life of **≤ 3 days**. Split big features with APEX build options or feature flags.
- Rebase on `main` (`git pull --rebase origin main`) before you request review.

## Why not long-lived develop/release branches?
APEX exports are generated metadata. Long divergence produces conflicts in page files that are hard to resolve by hand. Small, frequent merges keep conflicts rare and local.

## Resolving APEX merge conflicts
1. Prefer **re-exporting** over hand-merging: merge `main` into your branch, install the merged app into DEV, check it, then export again.
2. Never hand-edit component IDs in `.sql` export files.

## Environments and promotion
`dev` → `test` → `demo` → `prod`. The same `main` code moves through them; each database remembers what it has run (Liquibase). See [team-workflow.md](team-workflow.md) for the day-to-day steps and `scripts/deploy/deploy.sh`.

## Versioning & releases
- Semantic versioning `MAJOR.MINOR.PATCH`.
- Each release has `database/changelog/releases/<version>/changelog.xml`.
- Tag `vX.Y.Z` on `main`. Deploy that tag to demo, then to PROD (by pipeline once CI exists, otherwise `deploy.sh` run by the release owner).
- Hotfix: branch `hotfix/<ticket>` from the PROD tag, merge to `main`, tag a patch version.
