#!/usr/bin/env bash
# =============================================================================
# Environment Variables Validation Script
# =============================================================================
# Este script valida se no arquivo .env contém todas as variáveis necessárias
# e se elas não estão vazias
#
# Uso:
#   ./envs_validation.sh [var1] [var2] [var3] ...
#
# Exemplos:
#   ./envs_validation.sh                        # Valida apenas variáveis base
#   ./envs_validation.sh SECRET_KEY_BASE        # Valida base + SECRET_KEY_BASE
#   ./envs_validation.sh SECRET_KEY_BASE REDIS_URL  # Valida base + 2 extras
#
# Retorno:
#   0 - Sucesso (todas variáveis válidas)
#   1 - Erro (variáveis faltando ou vazias)
# =============================================================================

set -e

# =============================================================================
# VARIÁVEIS BASE (COMUNS A TODOS OS AMBIENTES)
# =============================================================================

REQUIRED_VARS_BASE=(
  "DB_HOST"
  "DB_PORT"
  "POSTGRES_USER"
  "POSTGRES_PASSWORD"
  "POSTGRES_DB"
  "RAILS_PORT"
  "RAILS_MAX_THREADS"
)

# =============================================================================
# VARIÁVEIS ADICIONAIS (VIA PARÂMETROS)
# =============================================================================

# Adiciona variáveis extras passadas como parâmetros
REQUIRED_VARS_EXTRA=("$@")

# Combina listas: base + extras
REQUIRED_VARS=("${REQUIRED_VARS_BASE[@]}" "${REQUIRED_VARS_EXTRA[@]}")

# =============================================================================
# VALIDAÇÃO DO ARQUIVO
# =============================================================================

echo "🔍 Validando .env..."
echo "📋 Variáveis obrigatórias: ${#REQUIRED_VARS[@]})"

# Verifica se arquivo existe
if [ ! -f ".env" ]; then
  echo "❌ Arquivo .env não existe!"
  exit 1
fi

# =============================================================================
# VALIDAÇÃO DAS VARIÁVEIS
# =============================================================================

# Arrays para erros
missing=()
empty=()

# Valida cada variável
for var in "${REQUIRED_VARS[@]}"; do
  if ! grep -q "^${var}=" ".env"; then
    missing+=("$var")
  else
    value=$(grep "^${var}=" ".env" | cut -d '=' -f2-)
    if [ -z "$value" ]; then
      empty+=("$var")
    fi
  fi
done

# =============================================================================
# REPORTA ERROS
# =============================================================================

# Reporta variáveis faltando
if [ ${#missing[@]} -gt 0 ]; then
  echo "❌ Variáveis faltando no .env:"
  printf '   - %s\n' "${missing[@]}"
  exit 1
fi

# Reporta variáveis vazias
if [ ${#empty[@]} -gt 0 ]; then
  echo "❌ Variáveis vazias no .env:"
  printf '   - %s\n' "${empty[@]}"
  exit 1
fi

echo "✅ Arquivo .env válido com todas as variáveis!"
exit 0
