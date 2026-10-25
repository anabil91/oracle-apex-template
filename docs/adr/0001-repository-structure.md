# ADR 0001: Monorepo layout for APEX + database + tests

**Status:** Accepted

## Context
Several developers change APEX pages, PL/SQL, and table structures at the same time. We need clean diffs, automatic reviewer assignment, and a structure that CI scripts can rely on.

## Decision
- One repository per APEX application family, containing `apex/`, `database/`, `tests/`, `scripts/`, `ci/`.
- APEX exported as split + readable YAML with original IDs.
- Database source stored as one file per object, under `schemas/<schema>/<object_type>/`.
- Tests mirror the source layout.

## Consequences
- An APEX change and the PL/SQL it depends on ship in **one PR** and are deployed and tested together.
- CODEOWNERS can route reviews by folder.
- Developers must export and commit only their own APEX changes (see CONTRIBUTING).
