#!/bin/bash
# =============================================================================
# Script Name : 03_run_autoupgrade_deploy.sh
# Description : Run AutoUpgrade deploy mode.
# =============================================================================

set -euo pipefail

CONFIG_FILE="${1:?Usage: $0 <autoupgrade_config_file>}"
AUTOUPGRADE_JAR="${AUTOUPGRADE_JAR:-$HOME/autoupgrade.jar}"

echo "Starting AutoUpgrade deploy."
echo "Useful console commands: lsj, status -job <JOB_ID>, status -job <JOB_ID> -a 30, logs"
java -jar "${AUTOUPGRADE_JAR}" -config "${CONFIG_FILE}" -mode deploy
