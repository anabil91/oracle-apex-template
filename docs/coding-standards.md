# Coding standards

Base: [Trivadis PL/SQL & SQL Coding Guidelines](https://trivadis.github.io/plsql-and-sql-coding-guidelines/) (enforced by lint). Project-specific additions:

## Naming

| Element | Convention | Example |
|---|---|---|
| Table | plural noun | `customers` |
| Primary key | `<table>_pk` | `customers_pk` |
| Foreign key | `<table>_<ref>_fk` | `orders_customers_fk` |
| Unique / Check | `<table>_<col>_uk` / `_ck` | `customers_email_uk` |
| Index | `<table>_<cols>_ix` | `orders_customer_id_ix` |
| View | `<name>_v` | `active_customers_v` |
| Business API package | `<entity>_api` | `customer_api` |
| Utility package | `<area>_util` | `string_util` |
| Test package | `test_<package>` | `test_customer_api` |
| Parameters | `pi_` in, `po_` out, `pio_` in out | `pi_customer_id` |
| Locals / globals / constants | `l_` / `g_` / `c_` | `l_count`, `c_max_rows` |
| Exceptions | `e_` | `e_invalid_email` |

## PL/SQL
- Anchor types with `%type` / `%rowtype`.
- No `WHEN OTHERS` unless it logs **and** re-raises.
- No `COMMIT` in API packages called from APEX.
- Dynamic SQL uses bind variables. Identifiers go through `dbms_assert`.
- Application error codes: `-20000` … `-20999`, declared as named exceptions in the package spec.
- Prefer set-based SQL over loops, and `bulk collect` / `forall` when looping is unavoidable.

## APEX
- Page processes, validations and computations call **one** package routine. No inline business logic.
- Use Authorization Schemes on pages/components. Never rely on hiding buttons.
- Keep output escaping on. Use `apex_escape` when generating HTML in PL/SQL.
- JavaScript/CSS lives in `apex/static_files/`, namespaced under `app.`.
- Pages are named `<Area> - <Purpose>` and grouped with Page Groups.

## SQL formatting
- Lower-case keywords and identifiers, 3-space indent (see `.editorconfig`).
- One column per line in `select` lists longer than 3 columns.
