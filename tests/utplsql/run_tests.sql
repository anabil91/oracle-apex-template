-- Runs all utPLSQL suites with console output (local use).
-- Usage: sql app_owner/***@db @tests/utplsql/run_tests.sql
-- Exits non-zero when any test fails.
-- CI uses utPLSQL-cli instead (scripts/test/) to produce JUnit + Cobertura in a single run.
whenever sqlerror exit failure rollback
set serveroutput on size unlimited
set feedback off

begin
   ut.run(
      a_path             => 'app_owner',
      a_reporter         => ut_documentation_reporter(),
      a_color_console    => false,
      a_raise_on_failure => true
   );
end;
/

exit success
