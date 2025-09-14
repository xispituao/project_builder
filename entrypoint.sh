set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

if [ "$RAILS_ENV" = "development" ]; then
  if ! bundle exec rails db:version 2>/dev/null; then
    echo "📦 Configurando banco de dados para desenvolvimento..."
    bundle exec rails db:create db:migrate
  fi
elif [ "$RAILS_ENV" = "production" ] || [ "$RAILS_ENV" = "staging" ]; then
  echo "🔄 Executando migrações do banco de dados..."
  bundle exec rails db:migrate
fi

exec "$@"
