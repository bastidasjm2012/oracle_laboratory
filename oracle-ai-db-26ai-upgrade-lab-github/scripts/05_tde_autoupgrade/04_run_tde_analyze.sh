#!/bin/bash
# =============================================================================
# Script Name : 04_run_tde_analyze.sh
# Description : Run AutoUpgrade analyze for encrypted database upgrade.
# =============================================================================

set -euo pipefail

CONFIG_FILE="${1:?Usage: $0 <autoupgrade_config_file>}"
AUTOUPGRADE_JAR="${AUTOUPGRADE_JAR:-$HOME/autoupgrade.jar}"

java -jar "${AUTOUPGRADE_JAR}" -config "${CONFIG_FILE}" -mode analyze

LOG_DIR=$(grep -E '^global\.autoupg_log_dir=' "${CONFIG_FILE}" | cut -d= -f2-)
cat "${LOG_DIR}/cfgtoollogs/upgrade/auto/status/status.log"
