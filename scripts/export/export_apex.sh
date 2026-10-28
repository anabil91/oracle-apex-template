#!/usr/bin/env bash
# Export APEX apps from an environment into apex/apps/<folder>/ as APEXlang (.apx).
#   scripts/export/export_apex.sh <env> [app_id]
#   app_id defaults to every app in APEX_APPS of environments/<env>.env
# Exports into scratch/ first and only replaces the repo folder when the export succeeded
# and the folder has no uncommitted changes. Read-only for the database.
set -euo pipefail

env_name="${1:-}"
only_app="${2:-}"
[[ "$env_name" =~ ^(dev|test|demo|prod)$ ]] || { echo "Usage: $0 <dev|test|demo|prod> [app_id]" >&2; exit 2; }

source "$(dirname "${BASH_SOURCE[0]}")/../lib/sqlcl.sh"
load_env "$env_name"
apex_apps >/dev/null   # fail early on a bad APEX_APPS

stage="$repo_root/scratch/export-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$stage"
exported=0

while read -r app_id folder; do
  [[ -z "$only_app" || "$only_app" == "$app_id" ]] || continue
  target="$repo_root/apex/apps/$folder"

  # Assigned on its own line so a failing git stops the script instead of reading as "clean".
  changes="$(git -C "$repo_root" status --porcelain -- "apex/apps/$folder")"
  if [[ -n "$changes" ]]; then
    echo "apex/apps/$folder has uncommitted changes. Commit or discard them first." >&2
    exit 1
  fi

  echo "== export app $app_id from $env_name ($(target_label)) =="
  run_sqlcl <<SQL
apex export -applicationid $app_id -exptype APEXLANG -skipexportdate -dir $(win_path "$stage")
SQL

  # SQLcl names the folder after the app alias. It must match APEX_APPS.
  [[ -d "$stage/$folder" ]] || {
    echo "Export did not create $folder. Created: $(ls "$stage")" >&2
    echo "Fix the folder name in APEX_APPS to match the app alias." >&2
    exit 1
  }

  # The export writes deployments/ (it holds the session state checksum salt). It is git-ignored.
  rm -rf "$target"
  mv "$stage/$folder" "$target"
  exported=$((exported + 1))

  if command -v uc-apx >/dev/null 2>&1; then
    uc-apx validate --app-dir "$target" --toon | grep -v '^note: mmdVersion' || true
  fi
done < <(apex_apps)

rm -rf "$stage"
[[ "$exported" -gt 0 ]] || { echo "No app exported. Check APEX_APPS${only_app:+ and app id $only_app}." >&2; exit 1; }

echo
git -C "$repo_root" status --short -- apex/apps
echo
echo "Review with 'git diff -- apex/apps'. Commit ONLY the files related to your change."
echo "Discard unrelated pages with 'git restore <file>'."
