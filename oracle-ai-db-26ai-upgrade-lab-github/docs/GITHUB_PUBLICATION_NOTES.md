# Notas para publicación GitHub / LinkedIn

## Título sugerido

Oracle AI Database 26ai Upgrade Lab Toolkit: AutoUpgrade, Multitenant, AWR, SPA, SPM, STA, Data Pump and TDE

## Descripción corta

Repositorio práctico para DBAs Oracle que desean documentar, automatizar y repetir escenarios de upgrade hacia Oracle AI Database 26ai usando AutoUpgrade, performance stability prescription, Data Pump y TDE.

## Post sugerido LinkedIn

Hoy comparto un toolkit práctico basado en el laboratorio *Hitchhiker's Guide for Upgrading to Oracle AI Database*.

El objetivo fue convertir un laboratorio guiado en una estructura reutilizable para DBAs:

✅ AutoUpgrade analyze/deploy  
✅ non-CDB to PDB conversion  
✅ AWR snapshots and AWR compare  
✅ SQL Tuning Sets  
✅ SQL Performance Analyzer  
✅ SQL Plan Management  
✅ SQL Tuning Advisor  
✅ Data Pump migration  
✅ TDE_PASSWORDS_REQUIRED troubleshooting  

Uno de los aprendizajes más importantes fue el manejo correcto de TDE con AutoUpgrade: las passwords no deben dejarse en texto plano en el `.cfg`, sino cargarse en el AutoUpgrade keystore con `-load_password`.

Este tipo de práctica ayuda a llevar un laboratorio académico a un procedimiento operativo reutilizable, auditable y más cercano a producción.

#Oracle #OracleDatabase #OracleAI #AutoUpgrade #DBA #OCI #Multitenant #TDE #DataPump
