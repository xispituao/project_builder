# Makefile para gerenciamento do projeto
.DEFAULT_GOAL := up

# Alvos phony (nao sao arquivos)
.PHONY: \
    up \
    up-interactive \
    down \
    logs \
    console \
    bash \
    migrate \
    clean \
    build \
    test \
    swagger

ifeq ($(ENVIRONMENT), production)
up:
	./up.sh production
down:
	docker compose -f docker-compose.production.yml down
logs:
	docker compose -f docker-compose.production.yml logs -f app
console:
	docker compose -f docker-compose.production.yml exec app rails console
bash:
	docker compose -f docker-compose.production.yml exec app bash
migrate:
	docker compose -f docker-compose.production.yml exec app rails db:migrate
clean:
	docker compose -f docker-compose.production.yml down -v
build:
	docker compose -f docker-compose.production.yml build
else ifeq ($(ENVIRONMENT), staging)
up:
	./up.sh staging
down:
	docker compose -f docker-compose.staging.yml down
logs:
	docker compose -f docker-compose.staging.yml logs -f app
console:
	docker compose -f docker-compose.staging.yml exec app rails console
bash:
	docker compose -f docker-compose.staging.yml exec app bash
migrate:
	docker compose -f docker-compose.staging.yml exec app rails db:migrate
clean:
	docker compose -f docker-compose.staging.yml down -v
build:
	docker compose -f docker-compose.staging.yml build
else
up:
	./up.sh development
up-interactive:
	./up.sh --no-detach
down:
	docker compose -f docker-compose.development.yml --env-file .env.development down
logs:
	docker compose -f docker-compose.development.yml --env-file .env.development logs -f app
console:
	docker compose -f docker-compose.development.yml --env-file .env.development exec app rails console
bash:
	docker compose -f docker-compose.development.yml --env-file .env.development exec app bash
migrate:
	docker compose -f docker-compose.development.yml --env-file .env.development exec app rails db:migrate
clean:
	docker compose -f docker-compose.development.yml --env-file .env.development down -v
build:
	docker compose -f docker-compose.development.yml --env-file .env.development build
test:
	docker compose -f docker-compose.development.yml --env-file .env.development exec app bundle exec rspec
swagger:
	docker compose -f docker-compose.development.yml --env-file .env.development exec app bundle exec rake rswag:specs:swaggerize
endif
