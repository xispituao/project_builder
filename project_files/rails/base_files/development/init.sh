#!/usr/bin/env bash
# =============================================================================
# Init Script - Development
# =============================================================================
# Este script é responsável por:
# 1. Copiar arquivo .env template para raiz do projeto
# 2. Validar variáveis de ambiente obrigatórias
# 3. Executar run_container.sh para build e up dos containers
# =============================================================================

set -e  # Para execução em caso de erro

# Parâmetros de entrada
DETACH=${1:-"--detach"}       # Modo detach (--detach ou --no-detach)

echo "🚀 Iniciando ambiente: development"

# Copia o arquivo .env template para .env
cp -f "./base_files/development/.env" "./.env"

./base_files/envs_validation.sh POSTGRES_DB_TEST

# Constrói as imagens Docker (sempre, mas com cache otimizado)
./base_files/run_container.sh development $DETACH
