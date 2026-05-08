#!/bin/bash
# =============================================================================
# Script Name : 00_prepare_cdb26_tde_wallet_dir.sh
# Description : Create the TDE wallet directory for target CDB26.
# Author      : Jesus Bastidas
# Version     : 1.0
# Platform    : Oracle Linux / Oracle AI Database 26ai
# =============================================================================

set -euo pipefail

CDB_NAME="${CDB_NAME:-CDB26}"
ORACLE_BASE_DIR="${ORACLE_BASE:-/u01/app/oracle}"
WALLET_ROOT_DIR="${WALLET_ROOT_DIR:-${ORACLE_BASE_DIR}/admin/${CDB_NAME}/wallet}"
TDE_WALLET_DIR="${TDE_WALLET_DIR:-${WALLET_ROOT_DIR}/tde}"

echo "=============================================================================="
echo "PREPARE TARGET CDB TDE WALLET DIRECTORY"
echo "CDB_NAME        : ${CDB_NAME}"
echo "WALLET_ROOT_DIR : ${WALLET_ROOT_DIR}"
echo "TDE_WALLET_DIR  : ${TDE_WALLET_DIR}"
echo "=============================================================================="

mkdir -p "${TDE_WALLET_DIR}"
chmod 700 "${WALLET_ROOT_DIR}" "${TDE_WALLET_DIR}"

echo "Directory created successfully:"
ls -ld "${WALLET_ROOT_DIR}" "${TDE_WALLET_DIR}"
