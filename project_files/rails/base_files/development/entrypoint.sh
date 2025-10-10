#!/usr/bin/env bash
# =============================================================================
# Entrypoint
# =============================================================================
# Este script é executado quando o container Rails inicia
# Responsável por:
# 1. Detectar se é primeira execução (servidor virgem)
# 2. Criar aplicação Rails se necessário
# 3. Configurar banco de dados e criar o banco de dados se necessário
# 4. Instalar dependências se necessário e executar migrações
# 5. Iniciar a aplicação Rails
# =============================================================================

set -e  # Para execução em caso de erro

echo "🚀 Iniciando aplicação Rails..."

# =============================================================================
# DETECÇÃO E CRIAÇÃO DA APLICAÇÃO RAILS
# =============================================================================

# Verifica se é primeira execução (servidor virgem)
# Condição: NÃO tem Gemfile OU NÃO tem pasta app OU NÃO tem config/application.rb
if [ -f "./.new_app" ] || [ ! -f Gemfile ] || [ ! -d app ] || [ ! -f config/application.rb ]; then
  echo "📦 Inicializando aplicação Rails..."

  # Cria a aplicação Rails
  rails new . --api --database=postgresql --skip-bundle --skip-git --skip-docker --force


  # Remove o .new_app se existir
  if [ -f "./.new_app" ]; then
    echo "🧹 Removendo .new_app..."
    rm -f "./.new_app"
  fi
fi

echo "🔧 Configuração do banco de dados..."
./base_files/generate_database_config.sh

./base_files/install_dependencies.sh false "" "--jobs 4 --retry 3"

./base_files/execute_migrations.sh true

echo "🎯 Executando comando: $@"
exec "$@"
