# Makefile para gerenciamento do projeto
.DEFAULT_GOAL := up
ENVIRONMENT ?= development

# Alvos phony (nao sao arquivos)
.PHONY: \
    up \
    up-interactive \
    down \
    restart \
    logs \
    console \
    bash \
    migrate \
    clean \
    build \
    test \
    rubocop \
    rubocop-fix \
    brakeman \
    swagger

ifeq ($(ENVIRONMENT), development)
up-interactive:
	./up.sh $(ENVIRONMENT) --no-detach
endif
up:
	./up.sh $(ENVIRONMENT)
test:
	docker compose -f docker-compose.yml --env-file .env exec app bundle exec rspec
down:
	docker compose -f docker-compose.yml --env-file .env down
restart:
	docker compose -f docker-compose.yml --env-file .env restart app
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
