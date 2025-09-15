#!/bin/bash

# Script para gerar database.yml automaticamente
# Este script substitui o database.yml gerado pelo Rails com nossa configuração

echo "🔧 Gerando configuração do banco de dados..."

# Verifica se o template existe
if [ ! -f "config/database.yml.template" ]; then
    echo "❌ Template config/database.yml.template não encontrado!"
    exit 1
fi

# Backup do database.yml original se existir
if [ -f "config/database.yml" ]; then
    echo "📄 Fazendo backup do database.yml original..."
    cp config/database.yml config/database.yml.backup
fi

# Copia o template para database.yml
echo "📝 Copiando template para database.yml..."
cp config/database.yml.template config/database.yml

echo "✅ Configuração do banco gerada com sucesso!"

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
