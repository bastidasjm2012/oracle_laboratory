-- =============================================================================
-- Script Name : 01_encrypt_target_cdb26.sql
-- Description : Configure TDE software keystore for target CDB26.
-- Author      : Jesus Bastidas
-- Version     : 1.0
-- Platform    : Oracle AI Database 26ai
--
-- Usage:
--   . cdb26
--   sql / as sysdba
--   @01_encrypt_target_cdb26.sql
--
-- Notes:
--   - WALLET_ROOT is static and requires database restart.
--   - This lab script uses oracle_4U for simplicity.
--   - Do not hardcode real passwords in production scripts.
-- =============================================================================

set echo on
set timing on
set linesize 220 pagesize 100
whenever sqlerror exit sql.sqlcode

prompt ================================================================================
prompt TASK 2 - ENCRYPT TARGET CDB26
prompt ================================================================================

prompt STEP 1 - Validate current container
show con_name

prompt STEP 2 - Configure WALLET_ROOT in SPFILE
alter system set wallet_root='/u01/app/oracle/admin/CDB26/wallet' scope=spfile;

prompt STEP 3 - Restart database because WALLET_ROOT is static
shutdown immediate
startup

prompt STEP 4 - Configure software keystore
alter system set tde_configuration='keystore_configuration=file' scope=both;

prompt STEP 5 - Create TDE keystore
administer key management create keystore '/u01/app/oracle/admin/CDB26/wallet/tde' identified by "oracle_4U";

prompt STEP 6 - Open TDE keystore
administer key management set keystore open force keystore identified by "oracle_4U";

prompt STEP 7 - Set TDE master encryption key
administer key management set key identified by "oracle_4U" with backup;

prompt STEP 8 - Create local auto-login keystore
administer key management create local auto_login keystore from keystore '/u01/app/oracle/admin/CDB26/wallet/tde' identified by "oracle_4U";

prompt STEP 9 - Validate wallet status
column wrl_parameter format a80
column status format a20
column wallet_type format a20

select wrl_type,
       wrl_parameter,
       status,
       wallet_type
from v$encryption_wallet;

prompt STEP 10 - Validate TDE parameters
show parameter wallet_root
show parameter tde_configuration

prompt ================================================================================
prompt TARGET CDB26 TDE CONFIGURATION COMPLETED
prompt ================================================================================
