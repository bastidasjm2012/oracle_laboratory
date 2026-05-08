#!/bin/bash
# =============================================================================
# Script Name : 05_recompile_all_containers.sh
# Description : Run utlrp.sql across CDB/PDB containers using catcon.pl.
# =============================================================================

set -euo pipefail

LOG_DIR="${1:-/tmp}"
BASE_NAME="${2:-utlrp_result}"

${ORACLE_HOME}/perl/bin/perl ${ORACLE_HOME}/rdbms/admin/catcon.pl \
-d ${ORACLE_HOME}/rdbms/admin \
-l "${LOG_DIR}" \
-b "${BASE_NAME}" \
-n 2 \
utlrp.sql

echo "Recompile completed. Logs:"
ls -l "${LOG_DIR}/${BASE_NAME}"*.log || true
