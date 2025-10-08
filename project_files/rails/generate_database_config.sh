#!/bin/bash
# =============================================================================
# Rails Project Builder - Database Config Generator
# =============================================================================
# Este script substitui o database.yml gerado pelo Rails com nossa configuração
# personalizada que usa variáveis de ambiente para flexibilidade entre ambientes
# =============================================================================

echo "🔧 Gerando configuração do banco de dados..."

# =============================================================================
# VALIDAÇÃO DO TEMPLATE
# =============================================================================

# Verifica se o template existe na raiz (copiado pelo build.sh)
if [ ! -f "database.yml.template" ]; then
  echo "❌ Template database.yml.template não encontrado!"
  exit 1
fi

# =============================================================================
# SUBSTITUIÇÃO DO DATABASE.YML
# =============================================================================

# Remove database.yml padrão do Rails se existir
echo "📝 Copiando template para database.yml..."
if [ -f "config/database.yml" ]; then
  rm -f config/database.yml
fi

# Move o template para config/database.yml (substitui configuração padrão)
mv database.yml.template config/database.yml

echo "✅ Configuração do banco gerada com sucesso!"

# =============================================================================
# INFORMAÇÕES DE DEBUG (APENAS DESENVOLVIMENTO)
# =============================================================================

# Mostra informações detalhadas apenas em desenvolvimento
if [ "$RAILS_ENV" = "development" ]; then
  echo "📋 Variáveis de ambiente configuradas:"
  echo "   - POSTGRES_DB: ${POSTGRES_DB:-avantsoft_app_development}"
  echo "   - POSTGRES_USER: ${POSTGRES_USER:-avantsoft}"
  echo "   - POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-password}"
  echo "   - DB_HOST: ${DB_HOST:-db}"
  echo "   - DB_INTERNAL_PORT: ${DB_INTERNAL_PORT:-5432}"
else
  echo "📋 Configuração do banco aplicada com sucesso"
fi
