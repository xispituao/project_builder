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

# Valida se o ambiente é válido
if [[ "$ENVIRONMENT" != "development" && "$ENVIRONMENT" != "staging" && "$ENVIRONMENT" != "production" ]]; then
  echo "❌ Erro: Ambiente inválido: $ENVIRONMENT"
  echo "💡 Ambientes válidos: development, staging, production"
  exit 1
fi

echo "🚀 Criando projeto '$PROJECT_NAME' para ambiente: $ENVIRONMENT"

# Verifica se a pasta do projeto já existe
if [ -d "$PROJECT_NAME" ]; then
  echo "❌ Erro: A pasta '$PROJECT_NAME' já existe!"
  echo "💡 Escolha outro nome ou remova a pasta existente."
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
for file in ./* ./.*; do
  basefile=$(basename "$file")
  
  # Ignora arquivos que não devem ser copiados para o projeto
  if [[ "$basefile" == ".gitignore" || "$basefile" == "makefile" || "$basefile" == "README.md" || "$basefile" == "build.sh" || "$basefile" == "$PROJECT_NAME" || "$basefile" == "." || "$basefile" == ".." ]]; then
    continue
  fi

  # Arquivos que começam com "project_script_" são renomeados (removendo o prefixo)
  if [[ "$basefile" == project_script* ]]; then
    newname="${basefile#project_script_}"  # Remove prefixo "project_script_"
    cp -r "$file" "$PROJECT_NAME/$newname"
  elif [[ "$basefile" != ".project_*" ]]; then
    # Outros arquivos são copiados com o nome original
    cp -r "$file" "$PROJECT_NAME/"
  fi
done

echo "✅ Arquivos copiados para dentro da pasta do projeto"

# =============================================================================
# EXECUÇÃO DO BUILD DO PROJETO
# =============================================================================

echo "🔨 Agora será executado o script de build do projeto"
cd $PROJECT_NAME
# Executa o script de build copiado (que era project_script_build.sh)
# Passa o ambiente e modo --detach --no-logs para execução silenciosa
./build.sh $ENVIRONMENT --detach --no-logs

echo "✅ Script de build do projeto executado com sucesso"

# =============================================================================
# AGUARDAR CONTAINER E APLICAÇÃO
# =============================================================================

echo "⏳ Aguardando o container subir e a aplicação Rails ser criada..."
echo "💡 Isso pode levar alguns minutos na primeira execução..."

# Configura comando docker compose baseado no ambiente
if [ "$ENVIRONMENT" = "development" ]; then
  COMPOSE_FILE="docker-compose.development.yml"
  ENV_FILE=".env.development"
  COMPOSE_CMD="docker compose -f $COMPOSE_FILE --env-file $ENV_FILE"
else
  COMPOSE_FILE="docker-compose.$ENVIRONMENT.yml"
  COMPOSE_CMD="docker compose -f $COMPOSE_FILE"
fi

# Aguarda o container estar rodando
echo "🔍 Verificando se o container está rodando..."
while ! $COMPOSE_CMD ps | grep -q "Up"; do
  echo "⏳ Aguardando container subir..."
  sleep 5
done

echo "✅ Container está rodando!"

# Aguarda a aplicação Rails estar pronta (apenas para development)
# Em staging/production, não fazemos curl pois pode não ter porta exposta
if [ "$ENVIRONMENT" = "development" ]; then
  echo "🔍 Verificando se a aplicação Rails está pronta..."
  while ! curl -f http://localhost:${RAILS_PORT:-3000} >/dev/null 2>&1; do
    echo "⏳ Aguardando aplicação Rails ficar pronta..."
    sleep 10
  done
  echo "✅ Aplicação Rails está pronta!"
else
  echo "✅ Aplicação Rails iniciada em modo $ENVIRONMENT!"
fi

# =============================================================================
# SUBSTITUIÇÃO DE ARQUIVOS PADRÃO
# =============================================================================

echo "🔄 Substituindo os arquivos padrões pelos pré-definidos"
cd ..  # Volta para o diretório do template

# Copia arquivos que começam com "project_" (exceto project_script_*)
# Estes arquivos sobrescrevem configurações padrão do Rails
for file in ./*; do
  basefile=$(basename "$file")

  if [[ "$basefile" == project_* && "$basefile" != project_script_* ]]; then
    newname="${basefile#project_}"  # Remove prefixo "project_"
    # Cria o arquivo se não existir
    if [ ! -e "$PROJECT_NAME/$newname" ]; then
      cp -rf "$file" "$PROJECT_NAME/$newname"
    fi
  fi
done

echo "✅ Arquivos pré-definidos copiados com sucesso"

# =============================================================================
# FINALIZAÇÃO - DERRUBAR CONTAINERS
# =============================================================================

echo "🛑 Derrubando containers após build..."
cd $PROJECT_NAME

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
