# =============================================================================
# Rails Project Builder - Makefile
# =============================================================================
# Este makefile fornece o comando de build para criar projetos Rails
# =============================================================================

# O alvo padrão é o build
.DEFAULT_GOAL := build

# Alvos phony (não são arquivos)
# Evita que o comando build seja tratado como alvo
.PHONY: build

# Variáveis com valores padrão
DEFAULT_PROJECT_NAME = my_app # Nome do projeto padrão
DEFAULT_PROJECT_PATH = . # Caminho do projeto padrão
DEFAULT_PROJECT_STACK = rails # Stack do projeto padrão

# Verifica se o primeiro argumento do comando é o build
ifeq (build, $(firstword $(MAKECMDGOALS))) 
	# Verifica se o nome do projeto não foi fornecido explicitamente. Ex: make build PROJECT_NAME=app
	ifeq ($(PROJECT_NAME),) 
		# Se não foi fornecido, verifica se o foi fornecido implicitamente após o build. Ex: make build app
		# Caso tenha sido é usado ele. Caso não, usa o nome padrão.
		PROJECT_NAME := $(or $(word 2, $(MAKECMDGOALS)), $(DEFAULT_PROJECT_NAME))
		$(eval $(PROJECT_NAME):;@:) # Evita que o nome do projeto seja tratado como alvo
	endif

	# Verifica se o caminho do projeto não foi fornecido explicitamente. Ex: make build PROJECT_PATH=~/Projetos/app
	ifeq ($(PROJECT_PATH),)
		# Se não foi fornecido, verifica se o foi fornecido implicitamente após o build. Ex: make build ~/Projetos/app
		# Caso tenha sido é usado ele. Caso não, usa o caminho padrão.
		PROJECT_PATH := $(or $(word 3, $(MAKECMDGOALS)), $(DEFAULT_PROJECT_PATH))
		$(eval $(PROJECT_PATH):;@:) # Evita que o caminho do projeto seja tratado como alvo
	endif

	# Verifica se o stack do projeto não foi fornecido explicitamente. Ex: make build <project_name> <project_path> PROJECT_STACK=rails
	ifeq ($(PROJECT_STACK),)
		# Se não foi fornecido, verifica se o foi fornecido implicitamente após o build. Ex: make build <project_name> <project_path> rails
		# Caso tenha sido é usado ele. Caso não, usa o caminho padrão.
		PROJECT_STACK := $(or $(word 4, $(MAKECMDGOALS)), $(DEFAULT_PROJECT_STACK))
		$(eval $(PROJECT_STACK):;@:) # Evita que o stack do projeto seja tratado como alvo
	endif
endif

# =============================================================================
# COMANDO PRINCIPAL
# =============================================================================

# Responsável por executar o script de build
build:
	./build.sh $(PROJECT_NAME) $(PROJECT_PATH) $(PROJECT_STACK)
