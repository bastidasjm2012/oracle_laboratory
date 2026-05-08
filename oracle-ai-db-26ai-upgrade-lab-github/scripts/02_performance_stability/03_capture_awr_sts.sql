-- =============================================================================
-- Script Name : 03_capture_awr_sts.sql
-- Description : Capture SQL workload from AWR into SQL Tuning Set.
-- =============================================================================

set serveroutput on
declare
  l_sts_name varchar2(30) := 'STS_CaptureAWR';
  l_begin_snap number;
  l_end_snap   number;
  l_cur        dbms_sqltune.sqlset_cursor;
begin
  begin
    dbms_sqltune.drop_sqlset(sqlset_name => l_sts_name);
  exception
    when others then
      if sqlcode != -13757 then
        raise;
      end if;
  end;

  dbms_sqltune.create_sqlset(sqlset_name => l_sts_name);

  select min(snap_id), max(snap_id)
    into l_begin_snap, l_end_snap
    from dba_hist_snapshot
   where begin_interval_time >= systimestamp - interval '2' hour;

  dbms_output.put_line('Snapshot Range between ' || l_begin_snap || ' and ' || l_end_snap || '.');

  open l_cur for
    select value(p)
    from table(
      dbms_sqltune.select_workload_repository(
        begin_snap        => l_begin_snap,
        end_snap          => l_end_snap,
        basic_filter      => 'parsing_schema_name not in (''SYS'',''SYSTEM'')',
        ranking_measure1  => 'elapsed_time',
        result_limit      => 100
      )
    ) p;

  dbms_sqltune.load_sqlset(
    sqlset_name     => l_sts_name,
    populate_cursor => l_cur
  );

  for r in (
    select statement_count
    from dba_sqlset
    where name = l_sts_name
  ) loop
    dbms_output.put_line('There are ' || r.statement_count || ' SQL Statements in ' || l_sts_name || '.');
  end loop;
end;
/
