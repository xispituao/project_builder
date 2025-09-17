#!/bin/bash
# =============================================================================
# Rails Project Builder - Script Principal
# =============================================================================
# Este script é o ponto de entrada para criar novos projetos Rails
# Funciona como um template que gera aplicações Rails completas com Docker
# Suporta múltiplos ambientes: development, staging, production
# =============================================================================

set -e  # Para execução em caso de erro

# Parâmetros de entrada
PROJECT_NAME=${1}        # Nome do projeto (obrigatório)
ENVIRONMENT=${2:-development}  # Ambiente (padrão: development)

# =============================================================================
# VALIDAÇÃO DE PARÂMETROS
# =============================================================================

# Verifica se o nome do projeto foi fornecido
if [ -z "$PROJECT_NAME" ]; then
  echo "❌ Erro: Nome do projeto é obrigatório!"
  echo "💡 Uso: ./build.sh <nome_do_projeto> [ambiente]"
  echo "   Ambientes: development (padrão), staging, production"
  exit 1
fi

echo "🚀 Criando projeto '$PROJECT_NAME'..."

# Verifica se a pasta do projeto já existe
if [ -d "$PROJECT_NAME" ]; then
  echo "❌ Erro: A pasta '$PROJECT_NAME' já existe!"
  echo "💡 Escolha outro nome ou apague a pasta existente."
  exit 1
fi

# Cria a pasta do projeto
mkdir -p $PROJECT_NAME

# =============================================================================
# CÓPIA DE ARQUIVOS DO TEMPLATE
# =============================================================================

echo "📁 Copiando os arquivos necessários para dentro da pasta do projeto"
shopt -s extglob  # Ativa padrões estendidos para nomes de arquivos

# Loop através de todos os arquivos do template (incluindo arquivos ocultos)
for file in ./project_files/* ./project_files/.*; do
  basefile=$(basename "$file")

  cp -r "$file" "$PROJECT_NAME/"
done

echo "✅ Arquivos copiados para dentro da pasta do projeto"

# =============================================================================
# EXECUÇÃO DO BUILD DO PROJETO
# =============================================================================

echo "🔨 Agora será executado o script de build do projeto"
cd $PROJECT_NAME
# Executa o script de build copiado (que era project_script_build.sh)
# Passa o ambiente como development e modo --detach --no-logs para execução silenciosa
./build.sh development --detach --no-logs

echo "✅ Script de build do projeto executado com sucesso"

# =============================================================================
# AGUARDAR CONTAINER E APLICAÇÃO
# =============================================================================

echo "⏳ Aguardando o container subir e a aplicação Rails ser criada..."
echo "💡 Isso pode levar alguns minutos na primeira execução..."

COMPOSE_CMD="docker compose -f docker-compose.development.yml --env-file .env.development"

# Aguarda o container estar rodando
echo "🔍 Verificando se o container está rodando..."
while ! $COMPOSE_CMD ps | grep -q "Up"; do
  echo "⏳ Aguardando container subir..."
  sleep 5
done

echo "✅ Container está rodando!"

# Aguarda a aplicação Rails estar pronta
echo "🔍 Verificando se a aplicação Rails está pronta..."
while ! docker logs "${PROJECT_NAME}-app-1" 2>&1 | grep -q "Listening on"; do
  echo "⏳ Aguardando aplicação Rails ficar pronta..."
  sleep 10
done
echo "✅ Aplicação Rails está pronta!"

# =============================================================================
# FINALIZAÇÃO - DERRUBAR CONTAINERS
# =============================================================================

echo "🛑 Derrubando containers após build..."

# Derruba os containers (reutiliza variáveis já configuradas)
$COMPOSE_CMD down
echo "✅ Containers derrubados com sucesso"

cd ..  # Volta para o diretório do template

# =============================================================================
# FINALIZAÇÃO
# =============================================================================

echo "🎉 Estrutura do projeto '$PROJECT_NAME' pronta para ser utilizada!"
echo "📋 Próximos passos:"
echo "   1. cd $PROJECT_NAME"
echo "   2. make dev ou make dev-interactive"
echo "🚀 Todos os comandos necessários estão no makefile dentro da pasta do projeto."
