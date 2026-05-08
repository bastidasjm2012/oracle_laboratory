set linesize 220 pagesize 200
column banner_full format a120
column name format a30
column open_mode format a20
column status format a15
column owner format a30
column object_type format a30

prompt ================================================================================
prompt POST-UPGRADE VALIDATION
prompt ================================================================================

show con_name
show pdbs

prompt ---- VERSION ----
select banner_full from v$version;

prompt ---- REGISTRY ----
select comp_id, comp_name, version, status
from dba_registry
order by comp_id;

prompt ---- INVALID OBJECTS ----
select owner, object_type, count(*) as invalid_count
from dba_objects
where status <> 'VALID'
group by owner, object_type
order by owner, object_type;

prompt ---- PDB PLUG IN VIOLATIONS ----
select name, cause, type, message, status
from pdb_plug_in_violations
order by time;

prompt ================================================================================
prompt END POST-UPGRADE VALIDATION
prompt ================================================================================
