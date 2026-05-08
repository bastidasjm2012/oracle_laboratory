set linesize 220 pagesize 100
column wrl_parameter format a80
column status format a20
column wallet_type format a20
column con_name format a30

prompt ================================================================================
prompt TDE WALLET HEALTH CHECK
prompt ================================================================================

select sys_context('USERENV','CON_NAME') as con_name,
       wrl_type,
       wrl_parameter,
       status,
       wallet_type
from v$encryption_wallet;

prompt
prompt If STATUS is CLOSED, open the keystore manually:
prompt ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY "<PASSWORD>";

prompt ================================================================================
prompt END TDE WALLET HEALTH CHECK
prompt ================================================================================
