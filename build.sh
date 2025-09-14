#!/bin/bash
set -e

ENVIRONMENT=${1:-development}
NO_DETACH=""

if [ "$ENVIRONMENT" = "development" ] && [ "$2" = "--no-detach" ]; then
	NO_DETACH="--no-detach"
	echo "🔍 Modo interativo ativado (sem -d)"
fi

echo "🚀 Iniciando build para ambiente: $ENVIRONMENT"

rm -f .dockerignore

if [ "$ENVIRONMENT" = "development" ]; then
    echo "📝 Usando .dockerignore.builder para desenvolvimento"
    cp .dockerignore.builder .dockerignore
else
    echo "📝 Usando .dockerignore.runtime para $ENVIRONMENT"
    cp .dockerignore.runtime .dockerignore
fi

echo "✅ .dockerignore configurado para $ENVIRONMENT"
echo "🐳 Iniciando build do Docker Compose..."

bash init.sh "$ENVIRONMENT" "$NO_DETACH"
