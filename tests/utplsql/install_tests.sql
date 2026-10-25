-- Installs all utPLSQL test packages into the current schema (non-prod only).
-- Add new test packages here: spec first, then body.
whenever sqlerror exit failure rollback
set define off

prompt Installing test packages...

@@app_owner/test_customer_api.pks
@@app_owner/test_customer_api.pkb

prompt Done.
