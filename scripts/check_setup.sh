#!/usr/bin/env bash
# Check that this machine and clone are ready. Changes nothing.
#   scripts/check_setup.sh [env]     env defaults to dev
set -uo pipefail

env_name="${1:-dev}"
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
problems=0

ok()   { echo "  ok    $1"; }
fail() { echo "  MISS  $1"; problems=$((problems + 1)); }

echo "Tools"
command -v git >/dev/null    && ok "git $(git --version | cut -d' ' -f3)"   || fail "git (install Git for Windows, which includes Git Bash)"
command -v sql >/dev/null    && ok "SQLcl $(MSYS_NO_PATHCONV=1 sql -V 2>/dev/null | grep -o 'Release [0-9.]*')" \
                             || fail "SQLcl 'sql' on PATH (need 26.1+ for APEXlang)"
command -v uc-apx >/dev/null && ok "uc-apx $(uc-apx version 2>/dev/null | head -1)" \
                             || fail "uc-apx (ships with SQLcl 26.x in its bin folder, or see github.com/United-Codes/uc-apx)"
[[ "${BASH_VERSINFO[0]}" -ge 4 ]] && ok "bash ${BASH_VERSION}" || fail "bash 4+ (scripts use associative arrays)"

echo "Repo"
# .gitattributes forces LF for text files, so core.autocrlf=true is harmless here. Mention it only.
[[ "$(git -C "$root" config core.autocrlf)" == "true" ]] && echo "  note  core.autocrlf=true (fine: .gitattributes forces LF)"
[[ -d "$root/.agents/skills/getting-started" ]] && ok "uc-apx skills in .agents/skills" \
  || fail "uc-apx skills: run 'uc-apx skills sync --agent universal'"

echo "Environment '$env_name'"
env_file="$root/environments/$env_name.env"
if [[ -f "$env_file" ]]; then
  ok "$env_file exists"
  for k in DB_USER APEX_WORKSPACE APEX_SCHEMA APEX_APPS; do
    grep -qE "^$k=.+" "$env_file" && ok "$k set" || fail "$k empty in $env_name.env"
  done
  grep -qE '^(SQLCL_CONNECTION|DB_CONNECT)=.+' "$env_file" && ok "connection set" \
    || fail "set SQLCL_CONNECTION (preferred) or DB_CONNECT in $env_name.env"
  git -C "$root" check-ignore -q "environments/$env_name.env" && ok "$env_name.env is git-ignored" \
    || fail "$env_name.env is NOT git-ignored"
else
  fail "$env_file (copy $env_name.env.example)"
fi

echo
if [[ "$problems" -eq 0 ]]; then
  echo "Ready. Next: scripts/deploy/deploy.sh $env_name --preview"
else
  echo "$problems problem(s). Fix them, then run this again."
  exit 1
fi
