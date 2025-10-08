# =============================================================================
# Project Builder - Script Principal
# =============================================================================
# Este script é o ponto de entrada para criar novos projetos Rails
# Funciona como um template que gera aplicações Rails completas com Docker
# Suporta múltiplos ambientes: development, staging, production
# =============================================================================

# =============================================================================
# STACKS DISPONÍVEIS
# =============================================================================

readonly STACKS=("rails")

# =============================================================================


# Para execução em caso de erro
set -e

# Parâmetros de entrada
# Nome do projeto (obrigatório)
PROJECT_NAME=${1}
# Caminho do projeto (obrigatório)
PROJECT_PATH=${2}
# Stack do projeto (obrigatório)
PROJECT_STACK=${3}

# =============================================================================
# VALIDAÇÃO DE PARÂMETROS
# =============================================================================

# Verifica se o nome do projeto foi fornecido
if [ -z "$PROJECT_NAME" ]; then
  echo "❌ Erro: Nome do projeto é obrigatório!"
  echo "💡 Uso: ./build.sh <nome_do_projeto> <caminho_do_projeto> <stack_do_projeto>"
  exit 1
fi

# Verifica se o caminho do projeto foi fornecido
if [ -z "$PROJECT_PATH" ]; then
  echo "❌ Erro: Caminho do projeto é obrigatório!"
  echo "💡 Uso: ./build.sh <nome_do_projeto> <caminho_do_projeto> <stack_do_projeto>"
  exit 1
fi

# Verifica se a stack do projeto foi fornecida
if [ -z "$PROJECT_STACK" ]; then
  echo "❌ Erro: Stack do projeto é obrigatória!"
  echo "💡 Uso: ./build.sh <nome_do_projeto> <caminho_do_projeto> <stack_do_projeto>"
  exit 1
fi

if [[ ! " ${STACKS[@]} " =~ " ${PROJECT_STACK} " ]]; then
  echo "❌ Erro: Stack do projeto não suportada!"
  echo "💡 Stacks disponíveis: ${STACKS[@]}"
  exit 1
fi

# Verifica se a pasta do projeto já existe no caminho fornecido
if [ -d "$PROJECT_PATH/$PROJECT_NAME" ]; then
  echo "❌ Erro: A pasta '$PROJECT_NAME' já existe no caminho '$PROJECT_PATH'!"
  echo "💡 Escolha outro nome, outro caminho ou apague a pasta existente."
  exit 1
fi

echo "🚀 Criando projeto '$PROJECT_NAME' em '$PROJECT_PATH' com a stack '$PROJECT_STACK'..."

# Cria a pasta do projeto no caminho fornecido
mkdir -p "$PROJECT_PATH/$PROJECT_NAME"

# =============================================================================
# CÓPIA DE ARQUIVOS DO TEMPLATE
# =============================================================================

echo "📁 Copiando os arquivos necessários para dentro da pasta do projeto"
shopt -s extglob  # Ativa padrões estendidos para nomes de arquivos

# Loop através de todos os arquivos do template (incluindo arquivos ocultos)
for file in ./project_files/$PROJECT_STACK/* ./project_files/$PROJECT_STACK/.*; do
  [ -e "$file" ] || continue  # Pula se o arquivo não existir
  cp -rf "$file" "$PROJECT_PATH/$PROJECT_NAME/"
done

echo "✅ Arquivos copiados para dentro da pasta do projeto"

# =============================================================================
# FINALIZAÇÃO
# =============================================================================

echo "🎉 Estrutura do projeto '$PROJECT_NAME' pronta para ser utilizada!"
echo "📋 Próximos passos:"
echo "   1. cd $PROJECT_PATH/$PROJECT_NAME"
echo "   2. make dev ou make dev-interactive"
echo "🚀 Todos os comandos necessários estão no makefile dentro da pasta do projeto."
