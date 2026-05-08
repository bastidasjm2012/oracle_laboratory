#!/bin/bash
# =============================================================================
# Script Name : 03_load_tde_passwords.sh
# Description : Start AutoUpgrade password loader for TDE credentials.
# =============================================================================

set -euo pipefail

CONFIG_FILE="${1:?Usage: $0 <autoupgrade_config_file>}"
AUTOUPGRADE_JAR="${AUTOUPGRADE_JAR:-$HOME/autoupgrade.jar}"

cat <<'INFO'

IMPORTANT:
- The first password requested protects the AutoUpgrade keystore.
- It is NOT the database TDE password.
- Then run these commands inside the TDE prompt:

  LIST
  ADD FTEX
  ADD CDB26
  LIST
  SAVE
  EXIT

The final LIST must show TDE Password = Verified and Action Required must be empty.

INFO

java -jar "${AUTOUPGRADE_JAR}" -config "${CONFIG_FILE}" -load_password
