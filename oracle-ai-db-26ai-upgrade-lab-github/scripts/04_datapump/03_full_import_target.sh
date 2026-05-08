#!/bin/bash
# =============================================================================
# Script Name : 03_full_import_target.sh
# Description : Full Data Pump import into target PDB.
# =============================================================================

set -euo pipefail

TARGET_SERVICE="${TARGET_SERVICE:-localhost/purple}"
DUMP_DIR_NAME="${DUMP_DIR_NAME:-DP_DIR}"
DUMP_OS_DIR="${DUMP_OS_DIR:-/u01/app/oracle/dpump}"
DUMP_FILE="${DUMP_FILE:-full_upgr_%U.dmp}"
LOG_FILE="${LOG_FILE:-full_import_purple.log}"
PARFILE="/tmp/impdp_full_target.par"

sqlplus -s / as sysdba <<SQL
whenever sqlerror exit sql.sqlcode
create or replace directory ${DUMP_DIR_NAME} as '${DUMP_OS_DIR}';
grant read, write on directory ${DUMP_DIR_NAME} to system;
SQL

cat > "${PARFILE}" <<EOF
userid=system/oracle@${TARGET_SERVICE}
directory=${DUMP_DIR_NAME}
dumpfile=${DUMP_FILE}
logfile=${LOG_FILE}
full=y
parallel=2
metrics=y
table_exists_action=replace
EOF

impdp parfile="${PARFILE}"
