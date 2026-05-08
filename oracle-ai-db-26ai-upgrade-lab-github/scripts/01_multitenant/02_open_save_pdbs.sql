-- =============================================================================
-- Script Name : 02_open_save_pdbs.sql
-- Description : Open selected PDBs and save their state.
-- Author      : Jesus Bastidas
-- Version     : 1.0
-- =============================================================================

whenever sqlerror exit sql.sqlcode

prompt Opening BLUE and GREEN PDBs and saving state.

alter pluggable database BLUE open;
alter pluggable database BLUE save state;

alter pluggable database GREEN open;
alter pluggable database GREEN save state;

show pdbs
