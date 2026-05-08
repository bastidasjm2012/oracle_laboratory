# Hitchhiker's Guide for Upgrading to Oracle AI Database 26ai - DBA Lab Toolkit

Repositorio técnico para documentar y automatizar actividades del laboratorio **Hitchhiker's Guide for Upgrading to Oracle AI Database**.

## Objetivo

Este repositorio consolida scripts, configuraciones y una guía operativa para ejecutar escenarios de upgrade hacia Oracle AI Database 26ai, incluyendo:

- Validación del ambiente.
- Exploración de arquitectura multitenant.
- Captura de workload con AWR y SQL Tuning Sets.
- Upgrade con AutoUpgrade.
- Conversión de non-CDB a PDB.
- Comparación de performance antes y después del upgrade.
- Uso de SQL Performance Analyzer, SQL Plan Management y SQL Tuning Advisor.
- Migraciones con Oracle Data Pump.
- Upgrade de base cifrada con TDE usando AutoUpgrade keystore.

## Arquitectura del laboratorio

El workshop trabaja con Oracle Database 19c, 21c, 23ai y Oracle AI Database 26ai. El flujo principal usa bases como `UPGR`, `FTEX` y `CDB26`, donde `UPGR` y `FTEX` son bases non-CDB origen y `CDB26` es el CDB destino para conversión a PDB.

## Estructura

```text
.
├── README.md
├── docs
│   ├── LAB_STEP_BY_STEP.md
│   ├── TROUBLESHOOTING_TDE_PASSWORDS_REQUIRED.md
│   └── GITHUB_PUBLICATION_NOTES.md
├── scripts
│   ├── 00_environment
│   ├── 01_multitenant
│   ├── 02_performance_stability
│   ├── 03_autoupgrade
│   ├── 04_datapump
│   └── 05_tde_autoupgrade
└── logs
```

## Uso rápido

```bash
chmod +x scripts/**/*.sh

# 1. Validar ambiente
./scripts/00_environment/00_env_check.sh

# 2. Generar configuración AutoUpgrade para UPGR
./scripts/03_autoupgrade/01_create_upgr_config.sh

# 3. Ejecutar analyze
./scripts/03_autoupgrade/02_run_autoupgrade_analyze.sh /home/oracle/scripts/upg-05-UPGR.cfg

# 4. Ejecutar deploy
./scripts/03_autoupgrade/03_run_autoupgrade_deploy.sh /home/oracle/scripts/upg-05-UPGR.cfg
```

## Variables principales

Ajustar según ambiente:

```bash
export SOURCE_HOME=/u01/app/oracle/product/19
export TARGET_HOME=/u01/app/oracle/product/26
export SOURCE_SID=UPGR
export TARGET_CDB=CDB26
export TARGET_PDB=UPGR
export AUTOUPGRADE_JAR=$HOME/autoupgrade.jar
export AUTOUPGRADE_LOG_DIR=/home/oracle/logs/autoupgrade-UPGR
```

## Nota de seguridad

No guardar passwords reales en GitHub. Para TDE, usar `java -jar autoupgrade.jar -config <cfg> -load_password` y almacenar las claves en el AutoUpgrade keystore, no en texto plano.

## Autor

Jesus Bastidas  
Senior Oracle DBA / OCI / High Availability / Database Upgrade & Migration
