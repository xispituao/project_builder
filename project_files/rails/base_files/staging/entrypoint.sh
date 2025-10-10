#!/usr/bin/env bash
# =============================================================================
# Entrypoint
# =============================================================================
# Este script é executado quando o container Rails inicia
# Responsável por:
# 1. Removendo PID file antigo
# 2. Configurar banco de dados se necessário
# 3. Instalar dependências se necessário e executar migrações
# 4. Iniciar a aplicação Rails
# =============================================================================

set -e  # Para execução em caso de erro

echo "🚀 Iniciando aplicação Rails..."

echo "🔧 Configuração do banco de dados..."
./base_files/generate_database_config.sh

./base_files/install_dependencies.sh true "development" "--jobs 4 --retry 3"

./base_files/execute_migrations.sh

echo "🎯 Iniciando aplicação..."

exec "$@"
