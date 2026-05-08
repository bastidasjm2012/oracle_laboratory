#!/bin/bash
# =============================================================================
# Script Name : 01_full_export_source.sh
# Description : Full Data Pump export from source database.
# =============================================================================

set -euo pipefail

ORACLE_SID="${ORACLE_SID:-UPGR}"
DUMP_DIR_NAME="${DUMP_DIR_NAME:-DP_DIR}"
DUMP_OS_DIR="${DUMP_OS_DIR:-/u01/app/oracle/dpump}"
DUMP_FILE="${DUMP_FILE:-full_upgr_%U.dmp}"
LOG_FILE="${LOG_FILE:-full_upgr_export.log}"
PARFILE="/tmp/expdp_full_${ORACLE_SID}.par"

mkdir -p "${DUMP_OS_DIR}"

sqlplus -s / as sysdba <<SQL
whenever sqlerror exit sql.sqlcode
create or replace directory ${DUMP_DIR_NAME} as '${DUMP_OS_DIR}';
grant read, write on directory ${DUMP_DIR_NAME} to system;
SQL

cat > "${PARFILE}" <<EOF
userid="/ as sysdba"
directory=${DUMP_DIR_NAME}
dumpfile=${DUMP_FILE}
logfile=${LOG_FILE}
full=y
parallel=2
metrics=y
exclude=statistics
EOF

expdp parfile="${PARFILE}"
