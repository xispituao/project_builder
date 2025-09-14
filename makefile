# Makefile para gerenciamento do projeto
.DEFAULT_GOAL := dev

# Alvos phony (não são arquivos)
.PHONY: dev dev-interactive prod staging down logs console migrate clean build

dev:
	./build.sh development

dev-interactive:
	./build.sh development --no-detach

prod:
	./build.sh production

staging:
	./build.sh staging

down:
	docker compose -f docker-compose.development.yml down

down-prod:
	docker compose -f docker-compose.production.yml down

down-staging:
	docker compose -f docker-compose.staging.yml down

logs:
	docker compose -f docker-compose.development.yml logs -f app

logs-prod:
	docker compose -f docker-compose.production.yml logs -f app

logs-staging:
	docker compose -f docker-compose.staging.yml logs -f app

console:
	docker compose -f docker-compose.development.yml exec app rails console

console-prod:
	docker compose -f docker-compose.production.yml exec app rails console

console-staging:
	docker compose -f docker-compose.staging.yml exec app rails console

migrate:
	docker compose -f docker-compose.development.yml exec app rails db:migrate

migrate-prod:
	docker compose -f docker-compose.production.yml exec app rails db:migrate

migrate-staging:
	docker compose -f docker-compose.staging.yml exec app rails db:migrate

clean:
	docker compose -f docker-compose.development.yml down -v

clean-prod:
	docker compose -f docker-compose.production.yml down -v

clean-staging:
	docker compose -f docker-compose.staging.yml down -v

build:
	docker compose -f docker-compose.development.yml build
