#!/bin/bash
# =============================================================================
# Rails Project Builder - Entrypoint
# =============================================================================
# Este script é executado quando o container Rails inicia
# Responsável por:
# 1. Detectar se é primeira execução (servidor virgem)
# 2. Criar aplicação Rails se necessário
# 3. Configurar banco de dados
# 4. Instalar dependências e executar migrações
# 5. Iniciar o servidor Rails
# =============================================================================

set -e  # Para execução em caso de erro

echo "🚀 Iniciando aplicação Rails..."

# =============================================================================
# LIMPEZA E PREPARAÇÃO
# =============================================================================

# Remove PID file antigo (evita conflitos em reinicializações)
if [ -f tmp/pids/server.pid ]; then
  echo "🧹 Removendo PID file antigo..."
  rm tmp/pids/server.pid
fi

# Garante que o diretório tmp/pids existe
mkdir -p tmp/pids

echo "✅ PostgreSQL já está pronto (garantido pelo depends_on)"

# =============================================================================
# DETECÇÃO E CRIAÇÃO DA APLICAÇÃO RAILS
# =============================================================================

# Verifica se é primeira execução (servidor virgem)
# Condição: NÃO tem Gemfile OU NÃO tem pasta app OU NÃO tem config/application.rb
if [ ! -f Gemfile ] || [ ! -d app ] || [ ! -f config/application.rb ]; then
  echo "📦 Inicializando aplicação Rails..."
  
  # Preserva .dockerignore e .dockerignore.runtime existentes
  if [ -f .dockerignore ]; then
    echo "📄 Preservando .dockerignore existente..."
    cp .dockerignore .dockerignore.backup
  fi
  
  if [ -f .dockerignore.runtime ]; then
    echo "📄 Preservando .dockerignore.runtime existente..."
    cp .dockerignore.runtime .dockerignore.runtime.backup
  fi
  
  # Cria nova aplicação Rails
  # --api: Aplicação API-only (sem views)
  # --database=postgresql: Configura PostgreSQL
  # --skip-bundle: Não executa bundle install (faremos depois)
  # --force: Sobrescreve arquivos existentes
  rails new . --api --database=postgresql --skip-bundle --force
  
  if [ -f .dockerignore.backup ]; then
    echo "📄 Restaurando .dockerignore original..."
    mv .dockerignore.backup .dockerignore
  fi
  
  if [ -f .dockerignore.runtime.backup ]; then
    echo "📄 Restaurando .dockerignore.runtime original..."
    mv .dockerignore.runtime.backup .dockerignore.runtime
  fi
  
  # Gera configuração do banco
  echo "🔧 Configurando banco de dados..."
  if [ -f generate_database_config.sh ]; then
    ./generate_database_config.sh
  else
    echo "⚠️ Script de configuração não encontrado, usando configuração padrão"
  fi

  if [ -f Dockerfile ]; then
    echo "🧹 Removendo Dockerfile padrão..."
    rm -f Dockerfile
  fi
fi

echo "📦 Instalando dependências..."
bundle install

echo "🗄️ Verificando se o banco de dados já existe..."
if bundle exec rails db:version > /dev/null 2>&1; then
  echo "🗄️ Banco de dados já existe, pulando criação."
else
  echo "🗄️ Criando banco de dados..."
  bundle exec rails db:create
fi
echo "🔄 Executando migrações do banco de dados..."
bundle exec rails db:migrate

# Log do comando apenas em desenvolvimento
if [ "$RAILS_ENV" = "development" ]; then
  echo "🎯 Executando comando: $@"
else
  echo "🎯 Iniciando aplicação..."
fi

exec "$@"
