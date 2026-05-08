#!/bin/bash
# =============================================================================
# Script Name : 00_env_check.sh
# Description : Validate Oracle AI Database upgrade lab environment.
# Author      : Jesus Bastidas
# Version     : 1.0
# Platform    : Oracle Linux / Oracle Database 19c-26ai
# =============================================================================

set -euo pipefail

echo "=============================================================================="
echo "ORACLE AI DATABASE UPGRADE LAB - ENVIRONMENT CHECK"
echo "Started: $(date)"
echo "=============================================================================="

echo
echo "---- OS VERSION ----"
cat /etc/os-release || true

echo
echo "---- CURRENT USER ----"
id

echo
echo "---- ORACLE ENVIRONMENT ----"
echo "ORACLE_HOME=${ORACLE_HOME:-NOT_SET}"
echo "ORACLE_SID=${ORACLE_SID:-NOT_SET}"
echo "PATH=$PATH"

echo
echo "---- LISTENER PROCESS ----"
ps -ef | grep LISTENER | grep -v grep || echo "WARNING: Listener process not found."

echo
echo "---- PMON PROCESSES ----"
ps -ef | grep ora_ | grep pmon | grep -v grep || echo "WARNING: No Oracle PMON process found."

echo
echo "---- LISTENER STATUS ----"
if command -v lsnrctl >/dev/null 2>&1; then
  lsnrctl status || true
else
  echo "lsnrctl not found in PATH."
fi

echo
echo "---- SQLPLUS/SQLCL VERSION ----"
if command -v sqlplus >/dev/null 2>&1; then
  sqlplus -v || true
fi

if command -v sql >/dev/null 2>&1; then
  sql -v || true
fi

echo
echo "---- AUTOUPGRADE VERSION ----"
if [[ -f "${HOME}/autoupgrade.jar" ]]; then
  java -jar "${HOME}/autoupgrade.jar" -version || true
else
  echo "autoupgrade.jar not found at ${HOME}/autoupgrade.jar"
fi

echo
echo "=============================================================================="
echo "Environment check completed: $(date)"
echo "=============================================================================="
