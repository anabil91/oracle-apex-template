# Shared helpers for scripts that call SQLcl. Source it, don't run it:
#   source "$(dirname "${BASH_SOURCE[0]}")/../lib/sqlcl.sh"
#
# environments/<env>.env keys used here:
#   SQLCL_CONNECTION  saved SQLcl connection name (preferred: the password stays in SQLcl's store)
#   DB_CONNECT        host:port/service, used only when SQLCL_CONNECTION is empty
#   DB_USER           expected session user. Every session stops if it connects as anyone else.
#   DB_PASSWORD       optional with DB_CONNECT. Leave empty to be prompted.
#   APEX_WORKSPACE, APEX_SCHEMA, APEX_APPS   see environments/README.md

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# SQLcl is a Windows program, so give it Windows-style paths (D:/...) when we can.
win_path() { (cd "$1" && pwd -W 2>/dev/null || pwd); }
repo_root_for_sqlcl="$(win_path "$repo_root")"

declare -A cfg

# load_env <env>: read environments/<env>.env as KEY=VALUE data. The file is never executed.
load_env() {
  local env_file="$repo_root/environments/$1.env" key value
  [[ -f "$env_file" ]] || { echo "Missing $env_file (copy $1.env.example)" >&2; exit 2; }
  while IFS='=' read -r key value; do
    value="${value%$'\r'}"
    [[ "$key" =~ ^[A-Z_]+$ ]] && cfg[$key]="$value"
  done < <(grep -E '^[A-Z_]+=' "$env_file")

  [[ -n "${cfg[DB_USER]:-}" ]] || { echo "DB_USER is not set in $env_file" >&2; exit 2; }
  if [[ -z "${cfg[SQLCL_CONNECTION]:-}" ]]; then
    [[ -n "${cfg[DB_CONNECT]:-}" ]] || { echo "Set SQLCL_CONNECTION or DB_CONNECT in $env_file" >&2; exit 2; }
    if [[ -z "${cfg[DB_PASSWORD]:-}" ]]; then
      local pw
      read -r -s -p "Password for ${cfg[DB_USER]}@${cfg[DB_CONNECT]}: " pw; echo
      cfg[DB_PASSWORD]="$pw"
    fi
  fi
}

target_label() { echo "${cfg[SQLCL_CONNECTION]:-${cfg[DB_USER]}@${cfg[DB_CONNECT]}}"; }

# run_sqlcl: stdin = SQLcl commands. Connects, refuses the wrong user, runs them, exits.
# The password never appears on the command line.
run_sqlcl() {
  local -a launch
  if [[ -n "${cfg[SQLCL_CONNECTION]:-}" ]]; then
    launch=(sql -S -noupdates -name "${cfg[SQLCL_CONNECTION]}")
  else
    launch=(sql -S -noupdates /nolog)
  fi
  { [[ -z "${cfg[SQLCL_CONNECTION]:-}" ]] &&
      printf 'connect %s/%s@%s\n' "${cfg[DB_USER]}" "${cfg[DB_PASSWORD]}" "${cfg[DB_CONNECT]}"
    printf 'whenever sqlerror exit failure rollback\nset define off\nset feedback off\n'
    printf "begin if user <> upper('%s') then raise_application_error(-20000, 'Connected as ' || user || ', expected %s'); end if; end;\n/\n" \
      "${cfg[DB_USER]}" "${cfg[DB_USER]}"
    cat
    printf 'exit\n'
  # Git Bash on Windows: MSYS_NO_PATHCONV stops "/nolog" being rewritten into a Windows path,
  # SQLCL_WRAPPED stops the `sql` launcher using winpty, which rejects piped input ("stdin is not a tty").
  # Set only for SQLcl: git and uc-apx still need Git Bash's path translation.
  } | MSYS_NO_PATHCONV=1 SQLCL_WRAPPED=1 "${launch[@]}" 2>&1 | { grep -v '^WARNING: ' || true; }
}

# apex_apps: print "<id> <folder>" for each entry of APEX_APPS=100:my-app,200:other-app
apex_apps() {
  local entry
  local -a entries=()
  [[ -n "${cfg[APEX_APPS]:-}" ]] || return 0
  : "${cfg[APEX_WORKSPACE]:?APEX_WORKSPACE is not set}" "${cfg[APEX_SCHEMA]:?APEX_SCHEMA is not set}"
  IFS=',' read -r -a entries <<< "${cfg[APEX_APPS]}"
  for entry in "${entries[@]}"; do
    [[ "$entry" =~ ^([0-9]+):([a-z0-9-]+)$ ]] || { echo "Bad APEX_APPS entry '$entry' (want <id>:<folder>)" >&2; exit 2; }
    echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]}"
  done
}
