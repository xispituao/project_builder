#!/bin/bash
# =============================================================================
# Rails Project Builder - Init Script
# =============================================================================
# Este script é responsável por:
# 1. Configurar variáveis de ambiente baseadas no tipo de ambiente
# 2. Validar arquivos de configuração necessários
# 3. Executar docker compose build e up
# 4. Gerenciar modo detach e logs
# =============================================================================

set -e  # Para execução em caso de erro

# Parâmetros de entrada
ENVIRONMENT=${1:-development}  # Ambiente (development, staging, production)
DETACH=${2:-"--detach"}       # Modo detach (--detach ou --no-detach)
WITH_LOGS=${3:-"--with-logs"} # Controle de logs (--with-logs ou --no-logs)

echo "🚀 Iniciando ambiente: $ENVIRONMENT"

# =============================================================================
# CONFIGURAÇÃO DE AMBIENTE
# =============================================================================

# Configura ambiente baseado no tipo
if [ "$ENVIRONMENT" = "development" ]; then
  # Desenvolvimento: usa arquivo .env.development
  ENV_FILE=".env.development"
  COMPOSE_CMD="docker compose -f docker-compose.development.yml --env-file $ENV_FILE"

  # Verifica se .env.sample existe (template)
  if [ ! -f ".env.sample" ]; then
    echo "❌ Arquivo .env.sample não encontrado!"
    echo "💡 Crie um arquivo .env.sample com as variáveis necessárias."
    exit 1
  fi
  echo "📝 Criando $ENV_FILE a partir do .env.sample..."
  cp -f .env.sample "$ENV_FILE"
  echo "✅ Arquivo $ENV_FILE criado com configurações do sample."
  echo "🔧 Edite o arquivo conforme necessário após o build."

  if [ ! -f .dockerignore ]; then
    echo "📝 Usando .dockerignore.development para desenvolvimento"
    cp -f .dockerignore.development .dockerignore.backup
  fi
else
  # Staging/Production: usa variáveis de ambiente do sistema
  COMPOSE_CMD="docker compose -f docker-compose.$ENVIRONMENT.yml"
  
  # Valida variáveis de ambiente obrigatórias
  REQUIRED_VARS="RAILS_PORT DB_HOST DB_PORT POSTGRES_PASSWORD POSTGRES_USER POSTGRES_DB SECRET_KEY_BASE"
  for var in $REQUIRED_VARS; do
    if [ -z "${!var}" ]; then
      echo "❌ Variável de ambiente $var não está definida!"
      echo "💡 Configure as variáveis de ambiente antes de continuar."
      exit 1
    fi
  done

  if [ ! -f ".dockerignore" ]; then
    echo "📝 Usando .dockerignore.runtime para $ENVIRONMENT"
    cp -f .dockerignore.runtime .dockerignore.backup
  fi
fi

# =============================================================================
# BUILD E EXECUÇÃO DOS CONTAINERS
# =============================================================================

# Constrói as imagens Docker (sempre, mas com cache otimizado)
echo "📦 Construindo imagem para $ENVIRONMENT..."
$COMPOSE_CMD build

echo "🐳 Iniciando containers..."

# Executa containers baseado no modo
if [ "$DETACH" = "--no-detach" ]; then
  echo "🔍 Executando em modo interativo (sem -d)"
  $COMPOSE_CMD up
else
  echo "📦 Executando em modo background (-d)"
  $COMPOSE_CMD up -d
fi

# =============================================================================
# MENSAGENS FINAIS
# =============================================================================

# Mostra mensagens finais apenas se não estiver em modo --no-logs
if [ "$WITH_LOGS" != "--no-logs" ]; then
  echo "✅ Ambiente $ENVIRONMENT iniciado com sucesso!"
  echo "📋 Para ver logs: make logs-$ENVIRONMENT"
  echo "🔧 Para console: make console-$ENVIRONMENT"
fi
