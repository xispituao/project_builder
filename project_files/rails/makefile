# Makefile para gerenciamento do projeto
.DEFAULT_GOAL := up
ENVIRONMENT ?= development

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

ifeq ($(ENVIRONMENT), development)
up-interactive:
	./up.sh $(ENVIRONMENT) --no-detach
endif
up:
	./up.sh $(ENVIRONMENT)
test:
	docker compose -f docker-compose.yml --env-file .env exec app bundle exec rspec
swagger:
	docker compose -f docker-compose.yml --env-file .env exec app bundle exec rake rswag:specs:swaggerize

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
