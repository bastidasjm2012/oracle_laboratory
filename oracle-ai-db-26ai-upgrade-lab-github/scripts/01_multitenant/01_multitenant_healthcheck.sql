set linesize 220 pagesize 200
column name format a30
column open_mode format a20
column restricted format a12
column con_name format a30
column state format a15
column tablespace_name format a30

prompt ================================================================================
prompt MULTITENANT HEALTH CHECK
prompt ================================================================================

prompt
prompt ---- CURRENT CONTAINER ----
show con_name

prompt
prompt ---- PDBS ----
show pdbs

prompt
prompt ---- V$PDBS ----
select con_id, name, open_mode, restricted
from v$pdbs
order by con_id;

prompt
prompt ---- V$CONTAINERS ----
select con_id, name, open_mode, restricted
from v$containers
order by con_id;

prompt
prompt ---- SAVED STATES ----
select con_name, state
from dba_pdb_saved_states
order by con_name;

prompt
prompt ---- NON DEFAULT PDB PARAMETERS ----
select con_id, name, value
from v$system_parameter
where isdefault='FALSE'
  and con_id != 0
order by con_id, name;

prompt
prompt ---- TABLESPACES BY CONTAINER ----
select con_id, con$name as name, tablespace_name
from cdb_tablespaces
order by con_id, tablespace_name;

prompt
prompt ================================================================================
prompt END MULTITENANT HEALTH CHECK
prompt ================================================================================
