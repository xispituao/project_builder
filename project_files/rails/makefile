# Makefile para gerenciamento do projeto
.DEFAULT_GOAL := dev

# Alvos phony (nao sao arquivos)
.PHONY: \
    dev \
    dev-interactive \
    prod \
    staging \
    down \
    down-prod \
    down-staging \
    logs \
    logs-prod \
    logs-staging \
    console \
    console-prod \
    console-staging \
    migrate \
    migrate-prod \
    migrate-staging \
    clean \
    clean-prod \
    clean-staging \
    build \
    test \
    test-prod \
    test-staging \
    swagger \
    bash \
    bash-prod \
    bash-staging

dev:
	./build.sh development

dev-interactive:
	./build.sh development --no-detach

prod:
	./build.sh production

staging:
	./build.sh staging

down:
	docker compose -f docker-compose.development.yml --env-file .env.development down

down-prod:
	docker compose -f docker-compose.production.yml down

down-staging:
	docker compose -f docker-compose.staging.yml down

logs:
	docker compose -f docker-compose.development.yml --env-file .env.development logs -f app

logs-prod:
	docker compose -f docker-compose.production.yml logs -f app

logs-staging:
	docker compose -f docker-compose.staging.yml logs -f app

console:
	docker compose -f docker-compose.development.yml --env-file .env.development exec app rails console

console-prod:
	docker compose -f docker-compose.production.yml exec app rails console

console-staging:
	docker compose -f docker-compose.staging.yml exec app rails console

bash:
	docker compose -f docker-compose.development.yml --env-file .env.development exec app bash

bash-prod:
	docker compose -f docker-compose.production.yml exec app bash

bash-staging:
	docker compose -f docker-compose.staging.yml exec app bash

migrate:
	docker compose -f docker-compose.development.yml --env-file .env.development exec app rails db:migrate

migrate-prod:
	docker compose -f docker-compose.production.yml exec app rails db:migrate

migrate-staging:
	docker compose -f docker-compose.staging.yml exec app rails db:migrate

clean:
	docker compose -f docker-compose.development.yml --env-file .env.development down -v

clean-prod:
	docker compose -f docker-compose.production.yml down -v

clean-staging:
	docker compose -f docker-compose.staging.yml down -v

build:
	docker compose -f docker-compose.development.yml --env-file .env.development build

test:
	docker compose -f docker-compose.development.yml --env-file .env.development exec app bundle exec rspec

test-prod:
	docker compose -f docker-compose.production.yml exec app bundle exec rspec

test-staging:
	docker compose -f docker-compose.staging.yml exec app bundle exec rspec

swagger:
	docker compose -f docker-compose.development.yml --env-file .env.development exec app bundle exec rake rswag:specs:swaggerize
