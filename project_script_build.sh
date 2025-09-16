#!/bin/bash
# =============================================================================
# Rails Project Builder - Project Build Script
# =============================================================================
# Este script é copiado como "build.sh" dentro da pasta do projeto
# Responsável por:
# 1. Configurar .dockerignore baseado no ambiente
# 2. Executar init.sh com parâmetros apropriados
# 3. Gerenciar modo detach e logs
# =============================================================================

set -e  # Para execução em caso de erro

# Parâmetros de entrada
ENVIRONMENT=${1:-development}  # Ambiente (development, staging, production)
DETACH=${2:-"--detach"}       # Modo detach (--detach ou --no-detach)
WITH_LOGS=${3:-"--with-logs"} # Controle de logs (--with-logs ou --no-logs)

# =============================================================================
# VALIDAÇÃO DE PARÂMETROS
# =============================================================================

# Valida modo interativo (apenas para development)
if [ "$DETACH" = "--no-detach" ]; then
  if [ "$ENVIRONMENT" != "development" ]; then
    echo "Modo interativo não é suportado para ambiente $ENVIRONMENT"
    exit 1
  fi
  echo "🔍 Modo interativo ativado"
else
  echo "🔍 Modo interativo desativado"
fi

# Valida modo de logs
if [ "$WITH_LOGS" == "--no-logs" ]; then
  echo "🔇 Modo sem logs ativado"
fi

echo "🚀 Iniciando build para ambiente: $ENVIRONMENT"

# =============================================================================
# CONFIGURAÇÃO DO DOCKERIGNORE
# =============================================================================

# Configura .dockerignore baseado no ambiente
# Development: usa .dockerignore.development (otimizado para desenvolvimento)
# Staging/Production: usa .dockerignore.runtime (otimizado para produção)
if [ "$ENVIRONMENT" != "development" ]; then
  echo "📝 Usando .dockerignore.runtime para $ENVIRONMENT"
  cp -f .dockerignore.runtime .dockerignore
else
  echo "📝 Usando .dockerignore.development para desenvolvimento"
  cp -f .dockerignore.development .dockerignore
fi

echo "✅ .dockerignore configurado para $ENVIRONMENT"
echo "🐳 Iniciando build do Docker Compose..."

# =============================================================================
# EXECUÇÃO DO INIT.SH
# =============================================================================

# Executa o script init.sh com os parâmetros apropriados
./init.sh "$ENVIRONMENT" "$DETACH" "$WITH_LOGS"
