#!/bin/bash
# =============================================================================
# Script Name : 01_create_ftex_tde_config.sh
# Description : Create AutoUpgrade config for encrypted FTEX non-CDB to PDB conversion.
# =============================================================================

set -euo pipefail

CONFIG_FILE="${1:-/home/oracle/scripts/upg-14-encrypted-db-upg-conv.cfg}"
LOG_DIR="${TDE_AUTOUPGRADE_LOG_DIR:-/home/oracle/logs/encrypted-db-upg-conv}"
AUTOUPG_KEYSTORE="${AUTOUPG_KEYSTORE:-/u01/app/oracle/keystore/autoupgrade}"
SOURCE_HOME="${SOURCE_HOME:-/u01/app/oracle/product/19}"
TARGET_HOME="${TARGET_HOME:-/u01/app/oracle/product/26}"
SOURCE_SID="${SOURCE_SID:-FTEX}"
TARGET_CDB="${TARGET_CDB:-CDB26}"
TARGET_PDB="${TARGET_PDB:-CYAN}"

mkdir -p "${AUTOUPG_KEYSTORE}"

cat > "${CONFIG_FILE}" <<EOF
global.autoupg_log_dir=${LOG_DIR}
global.keystore=${AUTOUPG_KEYSTORE}
upg1.source_home=${SOURCE_HOME}
upg1.target_home=${TARGET_HOME}
upg1.sid=${SOURCE_SID}
upg1.target_cdb=${TARGET_CDB}
upg1.target_pdb_name=${TARGET_PDB}
upg1.timezone_upg=NO
EOF

chmod 600 "${CONFIG_FILE}"

echo "Encrypted AutoUpgrade config created: ${CONFIG_FILE}"
cat "${CONFIG_FILE}"
