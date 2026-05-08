-- =============================================================================
-- Script Name : 02_capture_cursor_cache_sts.sql
-- Description : Capture SQL workload from cursor cache into SQL Tuning Set.
-- =============================================================================

set serveroutput on
declare
  l_sts_name varchar2(30) := 'STS_CaptureCursorCache';
begin
  dbms_output.put_line('Dropping SQL Tuning Set, if exists.');
  begin
    dbms_sqltune.drop_sqlset(sqlset_name => l_sts_name);
  exception
    when others then
      if sqlcode != -13757 then
        raise;
      end if;
  end;

  dbms_output.put_line('Creating SQL Tuning Set.');
  dbms_sqltune.create_sqlset(sqlset_name => l_sts_name);

  dbms_output.put_line('Polling cursor cache for 180 seconds every 10 seconds.');
  dbms_sqltune.capture_cursor_cache_sqlset(
    sqlset_name     => l_sts_name,
    time_limit      => 180,
    repeat_interval => 10,
    capture_option  => 'MERGE'
  );

  for r in (
    select statement_count
    from dba_sqlset
    where name = l_sts_name
  ) loop
    dbms_output.put_line('There are now ' || r.statement_count || ' SQL Statements in this STS.');
  end loop;
end;
/
