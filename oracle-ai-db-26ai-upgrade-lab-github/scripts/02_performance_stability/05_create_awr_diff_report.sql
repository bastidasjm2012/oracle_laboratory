-- =============================================================================
-- Script Name : 05_create_awr_diff_report.sql
-- Description : Generate AWR Compare Periods report.
-- Usage       : @05_create_awr_diff_report.sql <dbid1> <inst1> <bid1> <eid1> <dbid2> <inst2> <bid2> <eid2> <output_file>
-- =============================================================================

set termout off pagesize 0 linesize 32767 trimspool on trimout on feedback off verify off
spool &9

select output
from table(dbms_workload_repository.awr_diff_report_html(
  &1, &2, &3, &4,
  &5, &6, &7, &8
));

spool off
set termout on feedback on verify on
prompt AWR diff report generated: &9
