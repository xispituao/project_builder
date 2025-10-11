#!/usr/bin/env bash
# =============================================================================
# Up Script
# =============================================================================
# Responsável por:
# 1. Verificar se o ambiente é suportado
# 2. Copiar arquivos do ambiente específico
# 3. Executar init.sh de acordo com o ambiente e os parâmetros apropriados
# =============================================================================

set -e  # Para execução em caso de erro

# Lista de ambientes válidos
readonly VALID_ENVIRONMENTS=("development" "staging" "production")

# Parâmetros de entrada
ENVIRONMENT=${1:-development} # Ambiente (development, staging, production)
DETACH=${2:-"--detach"}       # Modo detach (--detach ou --no-detach)

# =============================================================================
# VALIDAÇÃO DE PARÂMETROS
# =============================================================================

# Verifica se o ambiente é suportado
if [[ ! " ${VALID_ENVIRONMENTS[@]} " =~ " ${ENVIRONMENT} " ]]; then
  echo "❌ Ambiente '$ENVIRONMENT' não suportado!"
  echo "💡 Ambientes suportados: ${VALID_ENVIRONMENTS[@]}"
  exit 1
fi

# =============================================================================
# EXECUÇÃO DO INIT.SH
# =============================================================================

# Copia os arquivos necessários de acordo com o ambiente
cp -rf ./base_files/$ENVIRONMENT/. .
cp -rf ./base_files/.gitignore .

# =============================================================================
# INICIALIZAÇÃO DO GIT
# =============================================================================

if [ ! -d ".git" ]; then
  git init -q
fi

./init.sh "$DETACH"
