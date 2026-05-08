#!/bin/bash
# =============================================================================
# Script Name : 05_run_tde_deploy.sh
# Description : Run AutoUpgrade deploy for encrypted database upgrade.
# =============================================================================

set -euo pipefail

CONFIG_FILE="${1:?Usage: $0 <autoupgrade_config_file>}"
AUTOUPGRADE_JAR="${AUTOUPGRADE_JAR:-$HOME/autoupgrade.jar}"

java -jar "${AUTOUPGRADE_JAR}" -config "${CONFIG_FILE}" -mode deploy
