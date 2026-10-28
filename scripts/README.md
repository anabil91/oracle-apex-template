# Scripts

The CI pipelines are thin wrappers around these scripts, and developers run the same scripts locally.
Each script reads its connection from environment variables (see `environments/`). Credentials are never passed as literals.

| Folder | Script (planned) | Purpose |
|---|---|---|
| `lib/` | `sqlcl.sh` ✅ | Shared: reads `environments/<env>.env`, connects (saved connection or prompt), refuses the wrong session user |
| `export/` | `export_apex.sh <env> [app_id]` ✅ | Export apps as APEXlang into `apex/apps/<alias>/`, staged in `scratch/`, refuses to overwrite uncommitted edits |
| `check_setup.sh` | ✅ | Check the tools and settings a new clone needs |
| `build/`  | `build.sh` | Validate changelogs, minify `static_files`, package `dist/<version>.zip` (database + apex + static files) |
| `deploy/` | `deploy.sh <env> [--preview]` ✅ | 1. `lb update` 2. `apex import` of each app in `APEX_APPS` (preview: `lb update-sql` + `apex validate`). Planned: recompile check, static files |
| `test/`   | `install_utplsql.sh` | Install the utPLSQL framework into the ephemeral CI database |
| `test/`   | `run_tests.sh` | Install test packages and run utPLSQL-cli (JUnit + Cobertura) |
| `test/`   | `check_coverage.sh` | Fail when coverage on changed files falls below the threshold |

Conventions:
- POSIX `bash` (CI runs on Linux). Add `.ps1` twins only if devs need them on Windows.
- `set -euo pipefail`; every SQLcl call uses `whenever sqlerror exit failure`.
- Exit non-zero on any failure so the pipeline stops.
