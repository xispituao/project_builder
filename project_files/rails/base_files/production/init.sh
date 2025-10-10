#!/usr/bin/env bash
# =============================================================================
# Init Script
# =============================================================================
# Este script é responsável por:
# 1. Executar o script envs_validation.sh
# 2. Executar o script run_container.sh
# =============================================================================

set -e  # Para execução em caso de erro

echo "🚀 Iniciando ambiente: production"

./base_files/envs_validation.sh SECRET_KEY_BASE

./base_files/run_container.sh production --detach
