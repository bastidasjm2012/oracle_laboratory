set serveroutput on
declare
  l_snap_id number;
begin
  l_snap_id := dbms_workload_repository.create_snapshot;
  dbms_output.put_line('-------------------------------------------');
  dbms_output.put_line('- AWR Snapshot with Snap-ID: ' || l_snap_id || ' created.');
  dbms_output.put_line('-------------------------------------------');
end;
/
