-- =============================================================================
-- Script Name : 02_create_target_pdb.sql
-- Description : Create target PDB for Data Pump import.
-- Usage       : @02_create_target_pdb.sql PURPLE oracle
-- =============================================================================

define PDB_NAME=&1
define ADMIN_PASSWORD=&2

whenever sqlerror exit sql.sqlcode

create pluggable database &PDB_NAME
admin user pdbadmin identified by "&ADMIN_PASSWORD"
roles=(dba);

alter pluggable database &PDB_NAME open;
alter pluggable database &PDB_NAME save state;

show pdbs
