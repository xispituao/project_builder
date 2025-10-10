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

# Verifica se o template existe
if [ ! -f "./base_files/database.yml" ]; then
  echo "❌ Template database.yml não encontrado!"
  exit 1
fi

# =============================================================================
# SUBSTITUIÇÃO DO DATABASE.YML
# =============================================================================

# Move o template para config/database.yml (substitui configuração padrão)
cp -f ./database.yml ../config/database.yml

echo "✅ Configuração do banco gerada com sucesso!"
