#!/bin/bash
# =============================================================================
# Script Name : 02_run_autoupgrade_analyze.sh
# Description : Run AutoUpgrade analyze mode and show summary log.
# =============================================================================

set -euo pipefail

CONFIG_FILE="${1:?Usage: $0 <autoupgrade_config_file>}"
AUTOUPGRADE_JAR="${AUTOUPGRADE_JAR:-$HOME/autoupgrade.jar}"

java -jar "${AUTOUPGRADE_JAR}" -config "${CONFIG_FILE}" -mode analyze

LOG_DIR=$(grep -E '^global\.autoupg_log_dir=' "${CONFIG_FILE}" | cut -d= -f2-)
STATUS_LOG="${LOG_DIR}/cfgtoollogs/upgrade/auto/status/status.log"

echo
echo "---- AutoUpgrade status log ----"
if [[ -f "${STATUS_LOG}" ]]; then
  cat "${STATUS_LOG}"
else
  echo "Status log not found: ${STATUS_LOG}"
fi
