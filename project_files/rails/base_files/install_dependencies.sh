#!/usr/bin/env bash
# =============================================================================
# Install Dependencies Script
# =============================================================================
# Este script instala as dependências do Rails via bundle
#
# Uso:
#   ./install_dependencies.sh <deployment> <without> <install_options>
#
# Parâmetros:
#   deployment: true ou false (padrão: false)
#   without: gems a pular (ex: "development test") (padrão: vazio)
#   install_options: opções extras (ex: "--jobs 4 --retry 3") (padrão: "--jobs 4 --retry 3")
#
# Exemplos:
#   ./install_dependencies.sh false "" "--jobs 4 --retry 3"              # Development
#   ./install_dependencies.sh true "development" "--jobs 4 --retry 3"    # Staging
#   ./install_dependencies.sh true "development test" "--jobs 4 --retry 3"  # Production
# =============================================================================

set -e

# Parâmetros de entrada
DEPLOYMENT=${1:-false}               # deployment mode (padrão: false)
WITHOUT=${2:-""}                     # gems to skip (padrão: vazio)
INSTALL_OPTIONS=${3:-"--jobs 4 --retry 3"}  # install options (padrão: --jobs 4 --retry 3)

echo "🧹 Removendo PID file antigo..."
mkdir -p "./.tmp/pids" && rm -f "./.tmp/pids/server.pid"

echo "📦 Verificando dependências..."

# Verifica se Gemfile existe
if [ ! -f "./Gemfile" ]; then
  echo "❌ Gemfile não encontrado!"
  exit 1
fi

# Verifica se as dependências já estão instaladas
if bundle check > /dev/null 2>&1; then
  echo "✅ Dependências já instaladas (cache aproveitado)"
  exit 0
fi

# =============================================================================
# INSTALAÇÃO DE DEPENDÊNCIAS
# =============================================================================

echo "📦 Instalando dependências do Rails..."
echo "🔧 Configuração:"
echo "   - deployment: $DEPLOYMENT"
echo "   - without: ${WITHOUT:-''}"
echo "   - options: $INSTALL_OPTIONS"

# Configura bundle
bundle config set --local deployment "$DEPLOYMENT"
bundle config set --local without "$WITHOUT"

# Instala dependências
if [ -n "$WITHOUT" ]; then
  bundle install $INSTALL_OPTIONS --without $WITHOUT
else
  bundle install $INSTALL_OPTIONS
fi

echo "✅ Dependências instaladas com sucesso!"
