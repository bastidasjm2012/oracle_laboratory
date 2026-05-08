# Paso a paso DBA - Upgrade a Oracle AI Database 26ai

## 1. Validación inicial del ambiente

Validar listener:

```bash
ps -ef | grep LISTENER | grep -v grep
lsnrctl status
```

Validar instancias:

```bash
ps -ef | grep ora_ | grep pmon | grep -v grep
```

Esperado en el laboratorio:

```text
ora_pmon_UPGR
ora_pmon_FTEX
ora_pmon_CDB26
```

## 2. Revisión multitenant

Conectarse al CDB destino:

```bash
. cdb26
sql / as sysdba
```

Listar PDBs:

```sql
show pdbs;
select con_id, name, open_mode, restricted from v$pdbs;
select con_id, name, open_mode, restricted from v$containers;
```

Abrir PDBs y guardar estado:

```sql
alter pluggable database BLUE open;
alter pluggable database BLUE save state;

alter pluggable database GREEN open;
alter pluggable database GREEN save state;
```

Validar servicios:

```bash
lsnrctl status
```

## 3. Captura de performance antes del upgrade

Conectarse a `UPGR`:

```bash
. upgr
sql / as sysdba
```

Crear snapshot AWR antes:

```sql
@/home/oracle/scripts/upg-03-awr-snapshot-snap-before.sql
```

Capturar SQL desde cursor cache:

```sql
@/home/oracle/scripts/upg-03-capture_cc.sql
```

Luego ejecutar la carga con HammerDB y crear snapshot AWR después:

```sql
@/home/oracle/scripts/upg-03-awr-snapshot-snap-after.sql
```

## 4. Captura de SQL desde AWR

```bash
. upgr
sql / as sysdba
```

```sql
@/home/oracle/scripts/upg-04-capture_awr.sql

select name, owner, statement_count
from dba_sqlset
where name like 'STS_Capture%';
```

## 5. AutoUpgrade - Analyze

Revisar versión:

```bash
java -jar autoupgrade.jar -version
```

Ejecutar analyze:

```bash
java -jar autoupgrade.jar \
-config /home/oracle/scripts/upg-05-UPGR.cfg \
-mode analyze
```

Validar resultado:

```bash
cat /home/oracle/logs/autoupgrade-UPGR/cfgtoollogs/upgrade/auto/status/status.log
```

Esperado:

```text
[Stage Name] PRECHECKS
[Status] SUCCESS
Check passed and no manual intervention needed
```

## 6. AutoUpgrade - Deploy

```bash
java -jar autoupgrade.jar \
-config /home/oracle/scripts/upg-05-UPGR.cfg \
-mode deploy
```

Comandos útiles dentro de la consola:

```text
lsj
status -job <JOB_ID>
status -job <JOB_ID> -a 30
logs
```

## 7. Validación post-upgrade

Conectarse al CDB destino:

```bash
. cdb26
sql / as sysdba
```

Validar PDB resultante:

```sql
show pdbs;
alter session set container=UPGR;
select * from v$version;
select count(*) from dba_objects where status='INVALID';
```

Recompilar inválidos:

```bash
$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl \
-d $ORACLE_HOME/rdbms/admin \
-l /tmp \
-b utlrp_result \
-n 2 \
utlrp.sql
```

## 8. Comparación AWR antes/después

Crear nueva carga post-upgrade y generar AWR Diff usando scripts del laboratorio o `awrrpt/awrddrpt`.

```sql
alter session set container=UPGR;
@/home/oracle/scripts/upg-06-awr-compare-snap-before.sql
-- ejecutar carga
@/home/oracle/scripts/upg-06-awr-compare-snap-after.sql
```

## 9. SQL Performance Analyzer / SQL Plan Management / SQL Tuning Advisor

Validar SQL Tuning Sets:

```sql
alter session set container=UPGR;

select count(*), sqlset_name
from dba_sqlset_statements
where sqlset_name like 'STS_Capture%'
group by sqlset_name
order by 2;
```

Usar los scripts de este repositorio como base para:
- Ejecutar SPA.
- Cargar planes en SPM.
- Crear tareas STA.
- Implementar recomendaciones con control.

## 10. Upgrade de base cifrada con TDE

La regla clave: no colocar passwords TDE en el archivo `.cfg`.

Usar:

```bash
java -jar autoupgrade.jar \
-config /home/oracle/scripts/upg-14-encrypted-db-upg-conv.cfg \
-load_password
```

Dentro:

```text
TDE> ADD FTEX
TDE> ADD CDB26
TDE> LIST
TDE> SAVE
TDE> EXIT
```

Luego:

```bash
java -jar autoupgrade.jar \
-config /home/oracle/scripts/upg-14-encrypted-db-upg-conv.cfg \
-mode analyze
```

