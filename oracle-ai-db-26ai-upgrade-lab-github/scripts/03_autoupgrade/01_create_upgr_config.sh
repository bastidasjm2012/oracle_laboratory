#!/bin/bash
# =============================================================================
# Script Name : 01_create_upgr_config.sh
# Description : Create AutoUpgrade config for UPGR non-CDB to PDB conversion.
# =============================================================================

set -euo pipefail

CONFIG_FILE="${1:-/home/oracle/scripts/upg-05-UPGR.cfg}"
LOG_DIR="${AUTOUPGRADE_LOG_DIR:-/home/oracle/logs/autoupgrade-UPGR}"
SOURCE_HOME="${SOURCE_HOME:-/u01/app/oracle/product/19}"
TARGET_HOME="${TARGET_HOME:-/u01/app/oracle/product/26}"
SOURCE_SID="${SOURCE_SID:-UPGR}"
TARGET_CDB="${TARGET_CDB:-CDB26}"
ADD_INIT_FILE="${ADD_INIT_FILE:-/home/oracle/scripts/upg-05-upgr_after_addinit.ora}"

cat > "${CONFIG_FILE}" <<EOF
global.autoupg_log_dir=${LOG_DIR}
upg1.source_home=${SOURCE_HOME}
upg1.target_home=${TARGET_HOME}
upg1.sid=${SOURCE_SID}
upg1.target_cdb=${TARGET_CDB}
upg1.restoration=no
upg1.add_after_upgrade_pfile=${ADD_INIT_FILE}
upg1.timezone_upg=NO
EOF

echo "AutoUpgrade config created: ${CONFIG_FILE}"
cat "${CONFIG_FILE}"
