#!/usr/bin/env bash
# Deploy database changes to one environment with Liquibase (SQLcl `lb`).
#   scripts/deploy/deploy.sh <env> [--preview]
#   env: dev | test | demo | prod   (reads environments/<env>.env)
# --preview shows what is pending and the SQL that would run, and changes nothing.
# Run from Git Bash on Windows. Needs SQLcl (`sql`) on PATH.
set -euo pipefail

env_name="${1:-}"
mode="${2:-}"
[[ "$env_name" =~ ^(dev|test|demo|prod)$ ]] || { echo "Usage: $0 <dev|test|demo|prod> [--preview]" >&2; exit 2; }

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
env_file="$root/environments/$env_name.env"
[[ -f "$env_file" ]] || { echo "Missing $env_file (copy $env_name.env.example)" >&2; exit 2; }

# Read KEY=VALUE as data. The file is never executed.
declare -A cfg
while IFS='=' read -r key value; do
  value="${value%$'\r'}"
  [[ "$key" =~ ^[A-Z_]+$ ]] && cfg[$key]="$value"
done < <(grep -E '^[A-Z_]+=' "$env_file")

for k in DB_CONNECT DB_USER; do
  [[ -n "${cfg[$k]:-}" ]] || { echo "$k is not set in $env_file" >&2; exit 2; }
done
if [[ -z "${cfg[DB_PASSWORD]:-}" ]]; then
  read -r -s -p "Password for ${cfg[DB_USER]}@${cfg[DB_CONNECT]}: " pw; echo
  cfg[DB_PASSWORD]="$pw"
fi

run_sqlcl() {  # stdin = SQLcl commands; the password never appears on the command line
  { printf 'connect %s/%s@%s\n' "${cfg[DB_USER]}" "${cfg[DB_PASSWORD]}" "${cfg[DB_CONNECT]}"
    printf 'whenever sqlerror exit failure rollback\nset define off\n'
    printf 'cd %s/database/changelog\n' "$root"
    cat
    printf 'exit\n'
  } | sql -S -noupdates /nolog
}

echo "== $env_name: pending changes =="
run_sqlcl <<'SQL'
lb status -changelog-file master.xml
SQL

if [[ "$mode" == "--preview" ]]; then
  echo "== SQL that would run =="
  run_sqlcl <<'SQL'
lb update-sql -changelog-file master.xml
SQL
  exit 0
fi

if [[ "$env_name" == "test" || "$env_name" == "demo" || "$env_name" == "prod" ]]; then
  read -r -p "Deploy to ${env_name^^} (${cfg[DB_CONNECT]})? Type the environment name to continue: " answer
  [[ "$answer" == "$env_name" ]] || { echo "Cancelled."; exit 1; }
fi

echo "== $env_name: deploying =="
run_sqlcl <<'SQL'
lb update -changelog-file master.xml
SQL
echo "== $env_name: done. Check for invalid objects and run the smoke test. =="
