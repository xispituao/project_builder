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

# =============================================================================
# DETECÇÃO E CRIAÇÃO DA APLICAÇÃO RAILS
# =============================================================================

# Verifica se é primeira execução (servidor virgem)
# Condição: NÃO tem Gemfile OU NÃO tem pasta app OU NÃO tem config/application.rb
if [ ! -f Gemfile ] || [ ! -d app ] || [ ! -f config/application.rb ]; then
  echo "📦 Inicializando aplicação Rails..."

  if [ -f .gitignore ]; then
    echo "📄 Preservando .gitignore existente..."
    cp .gitignore .gitignore.backup
  fi

  rails new . --api --database=postgresql --skip-bundle --force
  
  if [ -f .gitignore.backup ]; then
    echo "📄 Restaurando .gitignore original..."
    mv -f .gitignore.backup .gitignore
  fi
  
  # Gera configuração do banco
  echo "🔧 Configurando banco de dados..."
  if [ -f generate_database_config.sh ]; then
    ./generate_database_config.sh
  else
    echo "⚠️ Script de configuração não encontrado, usando configuração padrão"
  fi

  if [ -f .dockerignore.backup ]; then
    echo "📄 Restaurando .dockerignore original..."
    mv -f .dockerignore.backup .dockerignore
  fi

  if [ -f Dockerfile ]; then
    echo "🧹 Removendo Dockerfile padrão..."
    rm -f Dockerfile
  fi

  if [ -f .env ]; then
    echo "🧹 Removendo .env padrão..."
    rm -f .env
  fi
fi

# =============================================================================
# VERIFICAÇÃO DE DEPENDÊNCIAS
# =============================================================================

echo "📦 Verificando dependências..."
if [ -f Gemfile ]; then
  # Verifica se as dependências já estão instaladas
  if bundle check > /dev/null 2>&1; then
    echo "✅ Dependências já instaladas (cache aproveitado)"
  else
    echo "📦 Instalando dependências do Rails..."
    
    # Configura bundle baseado no ambiente
    if [ "$RAILS_ENV" = "production" ]; then
      echo "📦 Configurando bundle para produção..."
      bundle config set --local deployment 'true'
      bundle config set --local without 'development test'
      bundle install --jobs 4 --retry 3 --without development test
    elif [ "$RAILS_ENV" = "staging" ]; then
      echo "📦 Configurando bundle para staging..."
      bundle config set --local deployment 'true'
      bundle config set --local without 'development'
      bundle install --jobs 4 --retry 3 --without development
    else
      echo "📦 Configurando bundle para desenvolvimento..."
      bundle config set --local deployment 'false'
      bundle config set --local without ''
      bundle install --jobs 4 --retry 3
    fi
    
    echo "✅ Dependências instaladas com sucesso!"
  fi
  
  # Precompila assets para produção e staging
  if [ "$RAILS_ENV" = "production" ] || [ "$RAILS_ENV" = "staging" ]; then
    echo "🎨 Precompilando assets para $RAILS_ENV..."
    bundle exec rails assets:precompile RAILS_ENV=$RAILS_ENV
    echo "✅ Assets precompilados com sucesso!"
  fi
else
  echo "❌ Gemfile não encontrado!"
  exit 1
fi

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
