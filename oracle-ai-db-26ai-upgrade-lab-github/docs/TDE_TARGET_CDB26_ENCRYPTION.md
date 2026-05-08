# Task 2 - Encrypt Target CDB26

## Objetivo

Preparar el CDB destino `CDB26` para trabajar con TDE antes de ejecutar AutoUpgrade de una base cifrada como `FTEX`.

En el laboratorio, `CDB26` inicialmente no está cifrado. Para que AutoUpgrade pueda convertir `FTEX` non-CDB a PDB dentro de `CDB26`, el target CDB también debe tener su keystore TDE configurado.

## Paso 1 - Crear directorio del keystore

```bash
mkdir -p /u01/app/oracle/admin/CDB26/wallet/tde
```

Script incluido:

```bash
./scripts/05_tde_autoupgrade/00_prepare_cdb26_tde_wallet_dir.sh
```

## Paso 2 - Conectarse a CDB26

```bash
. cdb26
sql / as sysdba
```

## Paso 3 - Configurar WALLET_ROOT

`WALLET_ROOT` es un parámetro estático, por eso requiere reinicio.

```sql
alter system set wallet_root='/u01/app/oracle/admin/CDB26/wallet' scope=spfile;
shutdown immediate
startup
```

## Paso 4 - Configurar software keystore

```sql
alter system set tde_configuration='keystore_configuration=file' scope=both;
```

## Paso 5 - Crear keystore, abrirlo y crear master key

```sql
administer key management create keystore '/u01/app/oracle/admin/CDB26/wallet/tde' identified by "oracle_4U";
administer key management set keystore open force keystore identified by "oracle_4U";
administer key management set key identified by "oracle_4U" with backup;
administer key management create local auto_login keystore from keystore '/u01/app/oracle/admin/CDB26/wallet/tde' identified by "oracle_4U";
```

## Paso 6 - Validar

```sql
select wrl_type,
       wrl_parameter,
       status,
       wallet_type
from v$encryption_wallet;
```

Esperado:

```text
WRL_PARAMETER = /u01/app/oracle/admin/CDB26/wallet/tde/
STATUS        = OPEN
WALLET_TYPE   = PASSWORD or AUTOLOGIN
```

## Nota de seguridad

El laboratorio usa `oracle_4U` por simplicidad. En producción:

- usar password diferente para source y target;
- no guardar passwords en GitHub;
- proteger scripts con permisos restrictivos;
- considerar integración con un vault corporativo;
- respaldar `ewallet.p12` y `cwallet.sso` según política de seguridad.
