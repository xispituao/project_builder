#!/usr/bin/env bash
# =============================================================================
# Database Config Generator
# =============================================================================
# Este script substitui o database.yml gerado pelo Rails com nossa configuração
# personalizada que usa variáveis de ambiente para flexibilidade entre ambientes
# =============================================================================

set -e

echo "🔧 Gerando configuração do banco de dados..."

# =============================================================================
# VALIDAÇÃO DO TEMPLATE
# =============================================================================

# Verifica se o template existe em ./base_files/
if [ ! -e "./base_files/database.yml" ]; then
  echo "❌ Template database.yml não encontrado em ./base_files/!"
  exit 1
fi

# =============================================================================
# SUBSTITUIÇÃO DO DATABASE.YML
# =============================================================================

# Remove arquivo existente para evitar problemas de permissão (especialmente no CI)
rm -f ./config/database.yml

# Cria novo arquivo com o template
cat ./base_files/database.yml > ./config/database.yml

echo "✅ Configuração do banco gerada com sucesso!"
