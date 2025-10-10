#!/usr/bin/env bash
# =============================================================================
# Run Container Script
# =============================================================================
# Este script constrói a imagem Docker e sobe containers para o ambiente
#
# Uso:
#   ./run_container.sh <environment> [detach_mode]
#
# Parâmetros:
#   environment: development, staging, production (padrão: development)
#   detach_mode: --detach ou --no-detach (padrão: --detach)
#
# Exemplos:
#   ./run_container.sh development
#   ./run_container.sh production --detach
#   ./run_container.sh staging --no-detach
# =============================================================================

set -e

# Parâmetros de entrada
ENVIRONMENT=${1:-development}  # Ambiente (padrão: development)
DETACH=${2:-"--detach"}        # Modo detach (padrão: --detach)

# =============================================================================
# VALIDAÇÃO DE PARÂMETROS
# =============================================================================

# Verifica se o modo detach é suportado
if [ "$DETACH" != "--detach" ] && [ "$DETACH" != "--no-detach" ]; then
  echo "❌ Modo $DETACH não suportado!"
  echo "💡 Modos suportados: --detach ou --no-detach"
  exit 1
fi

# =============================================================================
# BUILD DA IMAGEM
# =============================================================================

echo "🚀 Iniciando build para $ENVIRONMENT"
echo "📦 Construindo imagem para $ENVIRONMENT..."

COMPOSE_CMD="docker compose -f docker-compose.yml --env-file .env"
$COMPOSE_CMD build

echo "✅ Imagem $ENVIRONMENT construída com sucesso!"

# =============================================================================
# EXECUÇÃO DOS CONTAINERS
# =============================================================================

echo "🐳 Iniciando containers..."

# Executa containers baseado no modo
if [ "$DETACH" = "--no-detach" ]; then
  echo "🔍 Executando em modo interativo (sem -d)"
  $COMPOSE_CMD up
else
  echo "📦 Executando em modo background (-d)"
  $COMPOSE_CMD up -d
fi

echo "✅ Ambiente $ENVIRONMENT iniciado com sucesso!"
echo "📋 Para ver logs: make logs"
echo "🔧 Para console: make console"
