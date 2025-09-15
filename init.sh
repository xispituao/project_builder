set -e

ENVIRONMENT=${1:-development}
NO_DETACH=${2:-""}

echo "🚀 Iniciando ambiente: $ENVIRONMENT"

# Configura ambiente baseado no tipo
if [ "$ENVIRONMENT" = "development" ]; then
	ENV_FILE=".env.development"
	COMPOSE_CMD="docker compose -f docker-compose.development.yml --env-file $ENV_FILE"
	
	# Cria arquivo .env se não existir
	if [ ! -f "$ENV_FILE" ]; then
		echo "⚠️  Arquivo $ENV_FILE não encontrado!"
		echo "📝 Criando arquivo básico de desenvolvimento..."
		cat > "$ENV_FILE" <<- 'EOF'
			RAILS_PORT=3000
			DB_HOST=db
			DB_PORT=5435
			POSTGRES_PASSWORD=password
			POSTGRES_USER=avantsoft
			POSTGRES_DB=avantsoft_app_development
		EOF
		echo "✅ Arquivo $ENV_FILE criado com configurações padrão."
		echo "🔧 Edite o arquivo conforme necessário antes de continuar."
		exit 1
	fi
else
	COMPOSE_CMD="docker compose -f docker-compose.$ENVIRONMENT.yml"
	
	# Valida variáveis de ambiente obrigatórias
	REQUIRED_VARS="RAILS_PORT DB_HOST DB_PORT POSTGRES_PASSWORD POSTGRES_USER POSTGRES_DB SECRET_KEY_BASE"
	for var in $REQUIRED_VARS; do
		if [ -z "${!var}" ]; then
			echo "❌ Variável de ambiente $var não está definida!"
			echo "💡 Configure as variáveis de ambiente antes de continuar."
			exit 1
		fi
	done
fi

echo "📦 Construindo imagem para $ENVIRONMENT..."
$COMPOSE_CMD build

echo "🐳 Iniciando containers..."

# Executa containers baseado no modo
if [ "$NO_DETACH" = "--no-detach" ]; then
	echo "🔍 Executando em modo interativo (sem -d)"
	$COMPOSE_CMD up
else
	echo "📦 Executando em modo background (-d)"
	$COMPOSE_CMD up -d
fi

echo "✅ Ambiente $ENVIRONMENT iniciado com sucesso!"
echo "📋 Para ver logs: make logs-$ENVIRONMENT"
echo "🔧 Para console: make console-$ENVIRONMENT"