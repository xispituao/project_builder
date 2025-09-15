# =============================================================================
# Rails Project Builder - Makefile
# =============================================================================
# Este makefile fornece comandos simplificados para criar projetos Rails
# Suporta múltiplos ambientes: development, staging, production
# =============================================================================

.DEFAULT_GOAL := build

# Alvos phony (não são arquivos)
.PHONY: build build-dev build-staging build-prod

# Variáveis com valores padrão
PROJECT_NAME ?= my_rails_app  # Nome do projeto (pode ser sobrescrito)
ENVIRONMENT ?= development    # Ambiente padrão (pode ser sobrescrito)

# =============================================================================
# COMANDOS PRINCIPAIS
# =============================================================================

# Comando principal - usa variáveis PROJECT_NAME e ENVIRONMENT
build:
	./build.sh $(PROJECT_NAME) $(ENVIRONMENT)

# Comandos específicos por ambiente
build-dev:
	./build.sh $(PROJECT_NAME) development

build-staging:
	./build.sh $(PROJECT_NAME) staging

build-prod:
	./build.sh $(PROJECT_NAME) production
