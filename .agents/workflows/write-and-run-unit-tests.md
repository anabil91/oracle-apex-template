---
description: Generate, install and run utPLSQL unit tests for changed package routines
---

# Workflow: write and run utPLSQL tests

Use when you add or change a public routine in `database/schemas/<schema>/packages/*.pkb`.
This is BLOCKING rule 5 in `AGENTS.md`, so a change without a test will fail review.

1. **Find the test package.** `packages/customer_api.pkb` maps to `tests/utplsql/app_owner/test_customer_api.pks/.pkb`.
   Create the pair if it does not exist. Copy the structure of `test_customer_api`.
2. **Annotate.** `--%suite(...)`, `--%suitepath(app_owner.<area>)`, one `--%test(plain English behaviour)` per behaviour.
3. **Cover** the happy path, each raised exception (named in the package spec), null and boundary input.
4. **Create data inside the test** (or `--%beforeeach`). Never rely on existing rows. Do not `COMMIT`.
5. **Install** (needs a non-prod connection the user has named): `@tests/utplsql/install_tests.sql`.
6. **Run**: `@tests/utplsql/run_tests.sql`, or `exec ut.run('app_owner.test_customer_api');` for one package.
7. **Report** the result honestly. If tests fail or cannot run (no DB, utPLSQL not installed), say so and do not claim success.
8. CI target: at least 80% line coverage on changed code. Test packages are never deployed to PROD.

Conventions: see `tests/README.md` and `docs/coding-standards.md` (`test_<package>`, `l_`, `pi_`, `po_` prefixes).
