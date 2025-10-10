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
else ifeq ($(ENVIRONMENT), staging)
up:
	./up.sh staging
else
up:
	./up.sh development
up-interactive:
	./up.sh development --no-detach
test:
	docker compose -f docker-compose.yml --env-file .env exec app bundle exec rspec
swagger:
	docker compose -f docker-compose.yml --env-file .env exec app bundle exec rake rswag:specs:swaggerize
endif

down:
	docker compose -f docker-compose.yml --env-file .env down
logs:
	docker compose -f docker-compose.yml --env-file .env logs -f app
console:
	docker compose -f docker-compose.yml --env-file .env exec app rails console
bash:
	docker compose -f docker-compose.yml --env-file .env exec app bash
migrate:
	docker compose -f docker-compose.yml --env-file .env exec app rails db:migrate
clean:
	docker compose -f docker-compose.yml --env-file .env down -v
build:
	docker compose -f docker-compose.yml --env-file .env build
