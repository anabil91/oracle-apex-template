## What & why
<!-- Ticket link + short description of the change -->

## Type
- [ ] APEX app change
- [ ] Database code (packages/views/...)
- [ ] Database structure (tables/columns/indexes) — changeset added
- [ ] Reference data
- [ ] CI / tooling

## Checklist
- [ ] Only files related to this change are committed (no unrelated APEX page noise)
- [ ] New/changed table DDL has a changeset in `database/changelog/releases/` with a rollback
- [ ] New objects are registered in `database/changelog/repeatable.xml`
- [ ] utPLSQL tests added/updated and pass locally
- [ ] No secrets or environment-specific values committed
- [ ] Pages I locked in APEX will be unlocked after merge

## Testing notes / screenshots
<!-- How was this verified? Screenshots for UI changes. -->

## Deployment notes
<!-- Destructive DDL, data migration, manual steps, ordering constraints -->
