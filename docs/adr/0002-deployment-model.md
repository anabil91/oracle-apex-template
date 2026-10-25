# ADR 0002: Liquibase (SQLcl) with versioned + repeatable changes

**Status:** Accepted

## Context
Every environment must reach the same state, re-running a deployment must be safe, and we must know which changes ran where.

## Decision
- Use **Liquibase through SQLcl** (`lb update`). It ships with SQLcl and records history in `DATABASECHANGELOG`.
- **Versioned** changesets (run once) for structure and data: tables, columns, indexes, constraints, sequences, data migrations. Grouped per release under `changelog/releases/<version>/`.
- **Repeatable** changesets (`runOnChange="true"`) for code: packages, views, triggers, procedures, functions. They point at the object's source file, so the file in `schemas/` is the single source of truth.
- Changesets run through SQLcl (`runWith="sqlcl"`) so the source files stay plain SQL*Plus-style scripts.

## Alternatives considered
- **SQLcl `project` command** (`project init/export/stage/release/deploy`): Oracle's newer opinionated workflow that generates changelogs from a dev schema. A good fit if the team prefers generating changes over hand-writing them. This layout can migrate to it later.
- **Flyway**: needs an extra tool. Its repeatable migrations are similar, but there's no native SQLcl/APEX integration.
- **Plain ordered scripts**: no tracking of what ran where, and no safe re-runs.

## Consequences
- Merged changesets are immutable. Corrections need new changesets (enforced in CI).
- New code objects must be registered in `repeatable.xml` (CI can check for unregistered files).
