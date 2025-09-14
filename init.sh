set -e

ENVIRONMENT=${1:-development}
NO_DETACH=${2:-""}

echo "🚀 Iniciando ambiente: $ENVIRONMENT"

if [ "$ENVIRONMENT" = "development" ]; then
	TARGET="builder"
	ENV_FILE=".env.development"
	COMPOSE_CMD="docker compose -f docker-compose.development.yml --env-file .env.development"
	
	if [ ! -f "$ENV_FILE" ]; then
		echo "⚠️  Arquivo $ENV_FILE não encontrado!"
		echo "📝 Criando arquivo básico de desenvolvimento..."
		cat > "$ENV_FILE" <<- 'EOF'
			# Configurações do Rails
			RAILS_PORT=3000
			
			# Configurações do Banco de Dados
			DB_USERNAME=avantsoft
			DB_DATABASE=avantsoft_app_development
			DB_PORT=5433
			DOCKER_NETWORK=avantsoft_dev_net
			SECRET_KEY_BASE=dev_secret_key
			POSTGRES_PASSWORD=password
		EOF
		echo "✅ Arquivo $ENV_FILE criado com configurações padrão."
		echo "🔧 Edite o arquivo conforme necessário antes de continuar."
		exit 1
	fi
else
	TARGET="runtime"
	COMPOSE_CMD="docker compose -f docker-compose.$ENVIRONMENT.yml --env-file .env.$ENVIRONMENT"
	
	REQUIRED_VARS="RAILS_ENV DB_USERNAME DB_PASSWORD DB_DATABASE SECRET_KEY_BASE"
	for var in $REQUIRED_VARS; do
		if [ -z "${!var}" ]; then
			echo "❌ Variável de ambiente $var não está definida!"
			echo "💡 Configure as variáveis de ambiente antes de continuar."
			exit 1
		fi
	done
fi

echo "📦 Construindo imagem para $ENVIRONMENT (target: $TARGET)..."
$COMPOSE_CMD build

echo "🐳 Iniciando containers..."

if [ "$ENVIRONMENT" = "development" ] && [ "$NO_DETACH" = "--no-detach" ]; then
	echo "🔍 Executando em modo interativo (sem -d)"
	$COMPOSE_CMD up
else
	echo "📦 Executando em modo background (-d)"
	$COMPOSE_CMD up -d
fi

echo "✅ Ambiente $ENVIRONMENT iniciado com sucesso!"
echo "📋 Para ver logs: make logs-$ENVIRONMENT"
echo "🔧 Para console: make console-$ENVIRONMENT"