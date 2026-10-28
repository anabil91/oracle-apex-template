#!/usr/bin/env bash
# Deploy one environment: database changes (Liquibase, SQLcl `lb`), then APEX apps (APEXlang import).
#   scripts/deploy/deploy.sh <env> [--preview]
#   env: dev | test | demo | prod   (reads environments/<env>.env)
# --preview shows pending changesets, the SQL that would run, and validates each app. Changes nothing.
# Run from Git Bash on Windows. Needs SQLcl (`sql`) on PATH.
set -euo pipefail

env_name="${1:-}"
mode="${2:-}"
[[ "$env_name" =~ ^(dev|test|demo|prod)$ ]] || { echo "Usage: $0 <dev|test|demo|prod> [--preview]" >&2; exit 2; }

source "$(dirname "${BASH_SOURCE[0]}")/../lib/sqlcl.sh"
load_env "$env_name"
apex_apps >/dev/null   # fail early on a bad APEX_APPS
changelog_dir="$repo_root_for_sqlcl/database/changelog"

echo "== $env_name ($(target_label)): pending database changes =="
run_sqlcl <<SQL
cd $changelog_dir
lb status -changelog-file master.xml
SQL

if [[ "$mode" == "--preview" ]]; then
  echo "== SQL that would run =="
  run_sqlcl <<SQL
cd $changelog_dir
lb update-sql -changelog-file master.xml
SQL
  while read -r app_id folder; do
    echo "== validate APEX app $app_id ($folder) =="
    run_sqlcl <<SQL
apex validate -input $repo_root_for_sqlcl/apex/apps/$folder -workspace ${cfg[APEX_WORKSPACE]}
SQL
  done < <(apex_apps)
  exit 0
fi

if [[ "$env_name" == "test" || "$env_name" == "demo" || "$env_name" == "prod" ]]; then
  read -r -p "Deploy to ${env_name^^} ($(target_label))? Type the environment name to continue: " answer
  [[ "$answer" == "$env_name" ]] || { echo "Cancelled."; exit 1; }
fi

echo "== $env_name: deploying database changes =="
run_sqlcl <<SQL
cd $changelog_dir
lb update -changelog-file master.xml
SQL

# Apps go after the database, because pages depend on tables and packages.
while read -r app_id folder; do
  echo "== $env_name: importing APEX app $app_id ($folder) =="
  run_sqlcl <<SQL
apex import -input $repo_root_for_sqlcl/apex/apps/$folder -workspace ${cfg[APEX_WORKSPACE]} -id $app_id -schema ${cfg[APEX_SCHEMA]}
SQL
done < <(apex_apps)

echo "== $env_name: done. Run the smoke test. =="
