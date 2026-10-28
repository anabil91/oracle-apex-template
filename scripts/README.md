# Scripts

The CI pipelines are thin wrappers around these scripts, and developers run the same scripts locally.
Each script reads its connection from environment variables (see `environments/`). Credentials are never passed as literals.

| Folder | Script (planned) | Purpose |
|---|---|---|
| `export/` | `export_apex.sql` ✅ | Export an app in split/readable format into `apex/apps/` |
| `build/`  | `build.sh` | Validate changelogs, minify `static_files`, package `dist/<version>.zip` (database + apex + static files) |
| `deploy/` | `deploy.sh <env> [--preview]` ✅ (database only; APEX/static steps planned) | 1. `lb update -changelog-file master.xml` 2. recompile invalid objects (fails if any remain invalid) 3. upload static files 4. install APEX app with `apex_application_install` |
| `test/`   | `install_utplsql.sh` | Install the utPLSQL framework into the ephemeral CI database |
| `test/`   | `run_tests.sh` | Install test packages and run utPLSQL-cli (JUnit + Cobertura) |
| `test/`   | `check_coverage.sh` | Fail when coverage on changed files falls below the threshold |

Conventions:
- POSIX `bash` (CI runs on Linux). Add `.ps1` twins only if devs need them on Windows.
- `set -euo pipefail`; every SQLcl call uses `whenever sqlerror exit failure`.
- Exit non-zero on any failure so the pipeline stops.
