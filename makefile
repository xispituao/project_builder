# =============================================================================
# Rails Project Builder - Makefile
# =============================================================================
# Este makefile fornece comandos simplificados para criar projetos Rails
# Suporta múltiplos ambientes: development, staging, production
# =============================================================================

.DEFAULT_GOAL := build

# Alvos phony (não são arquivos)
.PHONY: build

# Variáveis com valores padrão
PROJECT_NAME ?= my_rails_app  # Nome do projeto (pode ser sobrescrito)
ENVIRONMENT ?= development    # Ambiente padrão (pode ser sobrescrito)

# =============================================================================
# COMANDOS PRINCIPAIS
# =============================================================================

# Comando principal - usa variáveis PROJECT_NAME e ENVIRONMENT
build:
	./build.sh $(PROJECT_NAME)
