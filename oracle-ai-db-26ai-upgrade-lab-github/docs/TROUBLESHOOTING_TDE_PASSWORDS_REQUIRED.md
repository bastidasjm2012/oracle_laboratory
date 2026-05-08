# Troubleshooting: FTEX_TDE_PASSWORDS_REQUIRED / TDE_PASSWORDS_REQUIRED

## Síntoma

AutoUpgrade falla en prechecks:

```text
[Stage Name] PRECHECKS
[Status] FAILURE
[TDE_PASSWORDS_REQUIRED]
FTEX_TDE_PASSWORDS_REQUIRED
```

## Causa común

AutoUpgrade requiere passwords TDE cargadas en su propio keystore cuando la base origen o destino usa TDE. En una conversión non-CDB a PDB con TDE, se requieren las claves tanto del source non-CDB como del target CDB.

## Error frecuente

No usar:

```ini
upg1.tde_password=...
```

Ese parámetro puede ser ignorado por AutoUpgrade según versión.

Tampoco usar el wallet real de la base como `global.keystore`. `global.keystore` debe apuntar al keystore interno de AutoUpgrade.

## Configuración correcta

```ini
global.autoupg_log_dir=/home/oracle/logs/encrypted-db-upg-conv
global.keystore=/u01/app/oracle/keystore/autoupgrade

upg1.source_home=/u01/app/oracle/product/19
upg1.target_home=/u01/app/oracle/product/26
upg1.sid=FTEX
upg1.target_cdb=CDB26
upg1.target_pdb_name=CYAN
upg1.timezone_upg=NO
```

## Validaciones previas

```sql
select status, wallet_type, wrl_parameter
from v$encryption_wallet;
```

Esperado:

```text
STATUS = OPEN
WALLET_TYPE = PASSWORD or AUTOLOGIN
```

Validar archivos:

```bash
ls -l /u01/app/oracle/admin/FTEX/wallet/tde
```

Debe existir:

```text
ewallet.p12
cwallet.sso
```

## Cargar passwords en AutoUpgrade keystore

```bash
java -jar autoupgrade.jar \
-config /home/oracle/scripts/upg-14-encrypted-db-upg-conv.cfg \
-load_password
```

Primero se crea la password del keystore de AutoUpgrade. Esta no es la password TDE.

Dentro del prompt:

```text
TDE> LIST
TDE> ADD FTEX
TDE> ADD CDB26
TDE> LIST
TDE> SAVE
TDE> EXIT
```

El `LIST` debe mostrar:

```text
FTEX    Verified
CDB26   Verified
```

Con `Action Required` vacío.

## Re-ejecutar analyze

```bash
java -jar autoupgrade.jar \
-config /home/oracle/scripts/upg-14-encrypted-db-upg-conv.cfg \
-mode analyze
```

Resultado esperado:

```text
[Stage Name] PRECHECKS
[Status] SUCCESS
Check passed and no manual intervention needed
```

## RCA resumido

El error `TDE_PASSWORDS_REQUIRED` se resuelve cargando las passwords TDE del source y target en el AutoUpgrade keystore mediante `-load_password`. El archivo `.cfg` solo debe apuntar al keystore de AutoUpgrade mediante `global.keystore`.
