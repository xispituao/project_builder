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
  # Verifica se precisa inicializar Rails (Gemfile não existe OU gems não estão instaladas)
  if [ ! -f Gemfile ]; then
    echo "📦 Inicializando aplicação Rails..."
    
    if [ -f README.md ]; then
      echo "📄 Preservando README.md existente..."
      cp README.md README.md.backup
    fi
    
    if [ -f .gitignore ]; then
      echo "📄 Preservando .gitignore existente..."
      cp .gitignore .gitignore.backup
    fi
    
    if [ -f .gitattributes ]; then
      echo "📄 Preservando .gitattributes existente..."
      cp .gitattributes .gitattributes.backup
    fi
    
    if [ -f .dockerignore ]; then
      echo "📄 Preservando .dockerignore existente..."
      cp .dockerignore .dockerignore.backup
    fi
    
    if [ -f .dockerignore.runtime ]; then
      echo "📄 Preservando .dockerignore.runtime existente..."
      cp .dockerignore.runtime .dockerignore.runtime.backup
    fi
    
    if [ -f database.yml.template ]; then
      echo "📄 Preservando database.yml.template da raiz..."
      cp database.yml.template database.yml.template.backup
    fi
    
    if [ -d config ]; then
      echo "📄 Preservando pasta config existente..."
      cp -r config config.backup
    fi
    
    rails new . --api --database=postgresql --skip-bundle --force
    
    # Restaura arquivos originais se existiam
    if [ -f README.md.backup ]; then
      echo "📄 Restaurando README.md original..."
      mv README.md.backup README.md
    fi
    
    if [ -f .gitignore.backup ]; then
      echo "📄 Restaurando .gitignore original..."
      mv .gitignore.backup .gitignore
    fi
    
    if [ -f .gitattributes.backup ]; then
      echo "📄 Restaurando .gitattributes original..."
      mv .gitattributes.backup .gitattributes
    fi
    
    if [ -f .dockerignore.backup ]; then
      echo "📄 Restaurando .dockerignore original..."
      mv .dockerignore.backup .dockerignore
    fi
    
    if [ -f .dockerignore.runtime.backup ]; then
      echo "📄 Restaurando .dockerignore.runtime original..."
      mv .dockerignore.runtime.backup .dockerignore.runtime
    fi
    
    if [ -f database.yml.template.backup ]; then
      echo "📄 Movendo database.yml.template para config/..."
      mv database.yml.template.backup config/database.yml.template
      echo "🧹 Removendo template da raiz (não deve ficar aqui após build)..."
      rm -f database.yml.template
    fi
    
    if [ -d config.backup ]; then
      echo "📄 Restaurando pasta config original..."
      rm -rf config
      mv config.backup config
    fi
    
    # Instala dependências
    echo "📦 Instalando dependências..."
    bundle install
  elif [ ! -d .bundle ] || [ ! -f Gemfile.lock ]; then
    echo "📦 Instalando dependências Rails..."
    bundle install
  fi
  
  # Gera configuração do banco automaticamente
  echo "🔧 Configurando banco de dados automaticamente..."
  if [ -f scripts/generate_database_config.sh ]; then
    chmod +x scripts/generate_database_config.sh
    ./scripts/generate_database_config.sh
  else
    echo "⚠️ Script de configuração não encontrado, usando configuração padrão"
  fi
  
  # Executa migrações se necessário (só após ter Gemfile)
  if [ -f Gemfile ]; then
    if ! bundle exec rails db:version 2>/dev/null; then
      echo "📦 Configurando banco de dados para desenvolvimento..."
      bundle exec rails db:migrate
    fi
  fi
elif [ "$RAILS_ENV" = "production" ] || [ "$RAILS_ENV" = "staging" ]; then
  echo "🔄 Executando migrações do banco de dados..."
  bundle exec rails db:migrate
fi

# Remove Dockerfile sem sufixo após aplicação estar buildada
if [ -f Dockerfile ] && [ -f Dockerfile.development ] && [ -f Dockerfile.production ]; then
  echo "🧹 Removendo Dockerfile sem sufixo (não é mais necessário)..."
  rm -f Dockerfile
fi

# Log do comando apenas em desenvolvimento
if [ "$RAILS_ENV" = "development" ]; then
  echo "🎯 Executando comando: $@"
else
  echo "🎯 Iniciando aplicação..."
fi

exec "$@"
