#!/usr/bin/env bash
# =============================================================================
# Init Script
# =============================================================================
# Este script é responsável por:
# 1. Copiar o arquivo .env.sample para .env
# 2. Executar o script envs_validation.sh
# 3. Executar o script run_container.sh
# =============================================================================

set -e  # Para execução em caso de erro

# Parâmetros de entrada
DETACH=${1:-"--detach"}       # Modo detach (--detach ou --no-detach)

echo "🚀 Iniciando ambiente: development"

# Copia o arquivo .env.sample para .env
cp -f "./base_files/development/.env.sample" "./.env"

./base_files/envs_validation.sh

# Constrói as imagens Docker (sempre, mas com cache otimizado)
./base_files/run_container.sh development $DETACH
