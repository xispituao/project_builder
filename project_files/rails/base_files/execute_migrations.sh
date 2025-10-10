#!/usr/bin/env bash
# =============================================================================
# Execute Migrations Script
# =============================================================================
# Este script gerencia criação de banco de dados e execução de migrações
#
# Uso:
#   ./execute_migrations.sh [check_db]
#
# Parâmetros:
#   check_db: true ou false (padrão: true)
#     - true: Verifica se BD existe e cria se necessário
#     - false: Pula verificação, apenas executa migrações
#
# Exemplos:
#   ./execute_migrations.sh              # Verifica BD + migra
#   ./execute_migrations.sh true         # Verifica BD + migra
#   ./execute_migrations.sh false        # Só migra (não verifica)
# =============================================================================

set -e

# Parâmetro de entrada
CHECK_DB=${1:-false}  # Padrão: não verifica o banco

# =============================================================================
# CRIAÇÃO DO BANCO DE DADOS (SE NECESSÁRIO)
# =============================================================================

if [ "$CHECK_DB" = "true" ]; then
  echo "🗄️ Verificando se o banco de dados já existe..."
  if bundle exec rails db:version > /dev/null 2>&1; then
    echo "🗄️ Banco de dados já existe, pulando criação."
  else
    echo "🗄️ Criando banco de dados..."
    bundle exec rails db:create
  fi
fi

# =============================================================================
# EXECUÇÃO DAS MIGRAÇÕES
# =============================================================================

echo "🔄 Executando migrações do banco de dados..."
bundle exec rails db:migrate

echo "✅ Migrações executadas com sucesso!"
