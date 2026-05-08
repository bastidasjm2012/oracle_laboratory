-- =============================================================================
-- Script Name : 02_validate_cdb26_tde.sql
-- Description : Validate TDE configuration for target CDB26.
-- Author      : Jesus Bastidas
-- Version     : 1.0
-- =============================================================================

set linesize 220 pagesize 100
column wrl_parameter format a80
column status format a20
column wallet_type format a20
column tag format a30

prompt ================================================================================
prompt CDB26 TDE VALIDATION
prompt ================================================================================

prompt ---- CURRENT CONTAINER ----
show con_name

prompt ---- TDE PARAMETERS ----
show parameter wallet_root
show parameter tde_configuration

prompt ---- WALLET STATUS ----
select wrl_type,
       wrl_parameter,
       status,
       wallet_type
from v$encryption_wallet;

prompt ---- ENCRYPTION KEYS ----
select con_id,
       key_id,
       tag,
       creation_time,
       activation_time
from v$encryption_keys
order by con_id, creation_time;

prompt ================================================================================
prompt END CDB26 TDE VALIDATION
prompt ================================================================================
