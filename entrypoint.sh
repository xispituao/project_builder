#!/bin/bash
set -e

echo "🚀 Iniciando aplicação Rails..."

# Remove PID file antigo
if [ -f tmp/pids/server.pid ]; then
  echo "🧹 Removendo PID file antigo..."
  rm tmp/pids/server.pid
fi

# Garante que o diretório tmp/pids existe
mkdir -p tmp/pids

echo "✅ PostgreSQL já está pronto (garantido pelo depends_on)"

# Para desenvolvimento: inicializa Rails se necessário
if [ "$RAILS_ENV" = "development" ]; then
  if [ ! -d config ]; then
    echo "📦 Inicializando aplicação Rails..."
    
    # Preserva README.md existente se houver
    if [ -f README.md ]; then
      echo "📄 Preservando README.md existente..."
      cp README.md README.md.backup
    fi
    
    rails new . --api --database=postgresql --skip-bundle --force
    
    # Restaura README.md original se existia
    if [ -f README.md.backup ]; then
      echo "📄 Restaurando README.md original..."
      mv README.md.backup README.md
    fi
    
    # Gera configuração do banco automaticamente
    echo "🔧 Configurando banco de dados automaticamente..."
    if [ -f scripts/generate_database_config.sh ]; then
      chmod +x scripts/generate_database_config.sh
      ./scripts/generate_database_config.sh
    else
      echo "⚠️ Script de configuração não encontrado, usando configuração padrão"
    fi
  fi
  
  # Executa migrações se necessário
  if ! bundle exec rails db:version 2>/dev/null; then
    echo "📦 Configurando banco de dados para desenvolvimento..."
    bundle exec rails db:migrate
  fi
elif [ "$RAILS_ENV" = "production" ] || [ "$RAILS_ENV" = "staging" ]; then
  echo "🔄 Executando migrações do banco de dados..."
  bundle exec rails db:migrate
fi

echo "🎯 Executando comando: $@"
exec "$@"
