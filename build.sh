#!/bin/bash
set -e

ENVIRONMENT=${1:-development}

# Verifica se deve executar em modo interativo
if [ "$ENVIRONMENT" = "development" ] && [ "$2" = "--no-detach" ]; then
	echo "🔍 Modo interativo ativado (sem -d)"
	NO_DETACH="--no-detach"
else
	NO_DETACH=""
fi

echo "🚀 Iniciando build para ambiente: $ENVIRONMENT"

# Configura .dockerignore baseado no ambiente
if [ "$ENVIRONMENT" != "development" ]; then
    echo "📝 Usando .dockerignore.runtime para $ENVIRONMENT"
    cp .dockerignore.runtime .dockerignore
else
    echo "📝 Usando .dockerignore padrão para desenvolvimento"
fi

echo "✅ .dockerignore configurado para $ENVIRONMENT"
echo "🐳 Iniciando build do Docker Compose..."

./init.sh "$ENVIRONMENT" "$NO_DETACH"
