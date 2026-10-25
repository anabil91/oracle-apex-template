-- Exports an APEX application into apex/apps/f<ID>/ in split + readable format.
-- Usage (from repo root):  sql user/pass@db @scripts/export/export_apex.sql 100
whenever sqlerror exit failure
set termout on

define app_id = &1

cd apex/apps
apex export -applicationid &app_id -split -skipExportDate -expOriginalIds -exptype APPLICATION_SOURCE,READABLE_YAML
cd ../..

prompt
prompt Exported application &app_id into apex/apps/f&app_id
prompt Review "git status" and commit ONLY the files related to your change.
exit
