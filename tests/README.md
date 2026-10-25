# Tests (utPLSQL v3)

## Conventions
- Test packages live in `tests/utplsql/<schema>/` and mirror source: `customer_api` → `test_customer_api.pks/.pkb`.
- Suite path = `<schema>.<area>`, e.g. `--%suitepath(app_owner.customers)`, so CI can run subsets.
- Tests never commit. utPLSQL rolls back automatically after each test (default `--%rollback(auto)`).
- Test data is created inside the test (or `--%beforeeach`). Never depend on data already in the DB.
- One behaviour per test. Name tests in plain English with `--%test(...)`.
- Test packages are **not** deployed to PROD. CI installs them only into the test database.

## Running locally

```bash
sql app_owner/***@localhost/FREEPDB1 @tests/utplsql/run_tests.sql
```

Or from VS Code (SQL Developer extension) / SQLcl:

```sql
exec ut.run('app_owner');                          -- all suites
exec ut.run('app_owner.test_customer_api');        -- one package
exec ut.run(':app_owner.customers');               -- by suitepath
```

## In CI
CI uses [utPLSQL-cli](https://github.com/utPLSQL/utPLSQL-cli), which writes several reports from **one** run:

```bash
utplsql run app_owner/***@db \
  -p=app_owner \
  -f=ut_documentation_reporter  -c \
  -f=ut_junit_reporter          -o=reports/junit.xml \
  -f=ut_coverage_cobertura_reporter -o=reports/coverage.xml \
  -source_path=database/schemas/app_owner -owner=app_owner \
  -test_path=tests/utplsql/app_owner \
  --failure-exit-code=1
```

`-source_path` maps coverage back to repo file paths, so PR coverage annotations land on the correct lines.
Test packages (anything with `--%suite`) are excluded from coverage automatically.

## Installing test packages
```sql
@tests/utplsql/install_tests.sql
```
