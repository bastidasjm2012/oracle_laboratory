# TDE AutoUpgrade - FTEX to CDB26/CYAN

Este módulo documenta el flujo para upgrade/conversión de una base cifrada `FTEX` hacia el CDB destino `CDB26`, creando el PDB `CYAN`.

## 1. Preparar el target CDB26 para TDE

El laboratorio requiere cifrar primero el target CDB, porque `CDB26` inicialmente no está cifrado.

### Crear directorio del wallet

```bash
./00_prepare_cdb26_tde_wallet_dir.sh
```

Equivalente manual:

```bash
mkdir -p /u01/app/oracle/admin/CDB26/wallet/tde
```

### Configurar TDE en CDB26

```bash
. cdb26
sql / as sysdba
@01_encrypt_target_cdb26.sql
```

El script ejecuta:

```sql
alter system set wallet_root='/u01/app/oracle/admin/CDB26/wallet' scope=spfile;
shutdown immediate
startup
alter system set tde_configuration='keystore_configuration=file' scope=both;

administer key management create keystore '/u01/app/oracle/admin/CDB26/wallet/tde' identified by "oracle_4U";
administer key management set keystore open force keystore identified by "oracle_4U";
administer key management set key identified by "oracle_4U" with backup;
administer key management create local auto_login keystore from keystore '/u01/app/oracle/admin/CDB26/wallet/tde' identified by "oracle_4U";
```

> En producción no se recomienda hardcodear passwords. Usar la plantilla `01_encrypt_target_cdb26_safe_template.sql`.

### Validar TDE en CDB26

```sql
@02_validate_cdb26_tde.sql
```

Esperado:

```text
STATUS      OPEN
WALLET_TYPE PASSWORD or AUTOLOGIN
```

## 2. Crear configuración AutoUpgrade para FTEX

```bash
./01_create_ftex_tde_config.sh /home/oracle/scripts/upg-14-encrypted-db-upg-conv.cfg
```

La configuración debe usar un keystore propio de AutoUpgrade:

```ini
global.keystore=/u01/app/oracle/keystore/autoupgrade
```

No usar el wallet real de la base como `global.keystore`.

## 3. Cargar passwords TDE con AutoUpgrade

```bash
./03_load_tde_passwords.sh /home/oracle/scripts/upg-14-encrypted-db-upg-conv.cfg
```

Comandos dentro de `-load_password`:

```text
TDE> LIST
TDE> ADD FTEX
TDE> ADD CDB26
TDE> LIST
TDE> SAVE
TDE> EXIT
```

Resultado esperado:

```text
FTEX    Verified
CDB26   Verified
```

`Action Required` debe estar vacío.

## 4. Ejecutar Analyze

```bash
./04_run_tde_analyze.sh /home/oracle/scripts/upg-14-encrypted-db-upg-conv.cfg
```

Esperado:

```text
[Stage Name] PRECHECKS
[Status] SUCCESS
Check passed and no manual intervention needed
```

## 5. Ejecutar Deploy

```bash
./05_run_tde_deploy.sh /home/oracle/scripts/upg-14-encrypted-db-upg-conv.cfg
```

## Punto clave

No guardar passwords TDE dentro del archivo `.cfg`. Para AutoUpgrade con TDE, usar `-load_password` y guardar las claves en el AutoUpgrade keystore.
