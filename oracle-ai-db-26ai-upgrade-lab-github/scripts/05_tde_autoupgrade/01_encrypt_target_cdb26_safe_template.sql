-- =============================================================================
-- Script Name : 01_encrypt_target_cdb26_safe_template.sql
-- Description : Safer template for configuring TDE in target CDB26.
-- Author      : Jesus Bastidas
-- Version     : 1.0
--
-- Usage:
--   define TDE_PWD='YourStrongPassword'
--   @01_encrypt_target_cdb26_safe_template.sql
--
-- Important:
--   For production, avoid storing real passwords in scripts or GitHub.
-- =============================================================================

set echo on
set timing on
set linesize 220 pagesize 100
whenever sqlerror exit sql.sqlcode

define CDB_NAME='CDB26'
define WALLET_ROOT='/u01/app/oracle/admin/CDB26/wallet'
define TDE_WALLET='/u01/app/oracle/admin/CDB26/wallet/tde'

prompt ================================================================================
prompt CONFIGURE TDE FOR &&CDB_NAME
prompt ================================================================================

show con_name

alter system set wallet_root='&&WALLET_ROOT' scope=spfile;

prompt Restarting database because WALLET_ROOT is static.
shutdown immediate
startup

alter system set tde_configuration='keystore_configuration=file' scope=both;

administer key management create keystore '&&TDE_WALLET' identified by "&&TDE_PWD";
administer key management set keystore open force keystore identified by "&&TDE_PWD";
administer key management set key identified by "&&TDE_PWD" with backup;
administer key management create local auto_login keystore from keystore '&&TDE_WALLET' identified by "&&TDE_PWD";

column wrl_parameter format a80
column status format a20
column wallet_type format a20

select wrl_type,
       wrl_parameter,
       status,
       wallet_type
from v$encryption_wallet;

show parameter wallet_root
show parameter tde_configuration
