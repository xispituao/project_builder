# 🚀 Project Builder

Template completo e automatizado para criar projetos modernos com Docker, suportando múltiplas stacks (Rails, Python/Django, Node.js, etc), otimizado para desenvolvimento, staging e produção.

> ✅ **Status**: Projeto 100% funcional, testado e otimizado.

## ✨ Características

- 🚀 **Multi-Stack** - Rails (disponível), Python/Django, Node.js (em breve)
- 🐳 **Totalmente Dockerizado** - Ambiente consistente e isolado
- 🔧 **Auto-configuração** - Setup automático por stack
- 🛡️ **Multi-ambiente** - Development, staging e production configurados
- 📦 **Zero Configuração Manual** - Cria projetos do zero automaticamente
- 🏗️ **Template Reutilizável** - Use para múltiplos projetos sem conflitos
- 🔒 **Seguro** - Usuários não-root, sanitização de nomes, validação de variáveis
- ⚡ **Otimizado** - Imagens Docker enxutas, cache inteligente
- 🎯 **Padronizado** - Nomes únicos para containers, volumes e networks

## 📋 Pré-requisitos

- **Docker 20.10+**
- **Docker Compose 2.0+**
- **Make**
- **Sistema**: Linux, macOS ou Windows com WSL2

> ✅ **Testado em**: Ubuntu no WSL2, Windows 10

## 📦 Stacks Disponíveis

### ✅ Rails (Disponível)
- **Ruby 3.4.2** + **Rails 8.0.1**
- PostgreSQL 17.6
- API mode, Docker otimizado
- Scripts modulares e reutilizáveis

## 🚀 Quick Start

### Criar um Novo Projeto

```bash
# Sintaxe básica
make build <nome_projeto> [caminho=.] [stack=rails]

# Exemplos - Rails
make build blog                    # Cria projeto Rails "blog" no diretório atual
make build meu_app ~/projetos     # Cria em ~/projetos/meu_app
make build api ~/apps rails       # Especifica stack explicitamente

# Futuramente - Outras stacks
make build django_api ~/apps python   # Python/Django (futuro)
make build node_api ~/apps node       # Node.js (futuro)

# Com nome padrão
make build                        # Cria "my_app" com stack rails no diretório ./
```

### Iniciar o Projeto

```bash
# Acessar o projeto
cd blog  # ou cd ~/projetos/meu_app

# Development (modo background)
make up

# Development (modo interativo - vê logs em tempo real)
make up-interactive

# Staging
make up ENVIRONMENT=staging          # Define o ambiente explicitamente
make up                               # Ou usa a variável ENVIRONMENT do servidor

# Production
make up ENVIRONMENT=production       # Define o ambiente explicitamente
make up                               # Ou usa a variável ENVIRONMENT do servidor
```

## 📂 Estrutura do Template Builder

```
project_builder/  (template raiz)
├── makefile                    # Build de novos projetos
├── build.sh                    # Script principal de criação
├── README.md                   # Documentação
└── project_files/              # Templates por stack
    ├── rails/                  ✅ Stack Rails (disponível)
    │   ├── makefile
    │   ├── up.sh
    │   └── base_files/
    │       ├── development/
    │       ├── staging/
    │       ├── production/
    │       └── scripts auxiliares
    ├── python/                 🔄 Stack Python (futuro)
    ├── node/                   🔄 Stack Node.js (futuro)
    └── go/                     🔄 Stack Go (futuro)
```

## 📂 Estrutura do Projeto Gerado (Rails)

```
blog/  (seu projeto Rails)
├── makefile                    # Comandos de gerenciamento
├── up.sh                       # Script de inicialização
├── .env                        # Variáveis de ambiente (gerado)
├── docker-compose.yml          # Configuração Docker (copiado do ambiente)
├── Dockerfile                  # Imagem Docker (copiado do ambiente)
├── entrypoint.sh               # Script de inicialização do container
├── init.sh                     # Script de setup do ambiente
│
├── base_files/                 # Templates e scripts auxiliares
│   ├── development/
│   │   ├── .env                # Template de variáveis
│   │   ├── docker-compose.yml
│   │   ├── Dockerfile
│   │   ├── init.sh
│   │   └── entrypoint.sh
│   ├── staging/
│   │   └── ...
│   ├── production/
│   │   └── ...
│   ├── envs_validation.sh      # Validação de variáveis
│   ├── run_container.sh        # Build e execução de containers
│   ├── install_dependencies.sh # Instalação de gems
│   ├── execute_migrations.sh   # Migrações de banco
│   └── generate_database_config.sh  # Geração de database.yml
│
└── app/                        # Aplicação Rails (gerada na primeira execução)
    ├── app/
    ├── config/
    ├── db/
    └── ...
```

## 🔧 Comandos Disponíveis

### Comandos Principais

```bash
# Subir aplicação
make up                    # Development (background)
make up-interactive        # Development (interativo)

# Outros ambientes
make up ENVIRONMENT=staging
make up ENVIRONMENT=production

# Gerenciamento
make down                  # Para containers
make logs                  # Ver logs em tempo real
make console               # Acessa console Rails
make bash                  # Acessa bash do container
make migrate               # Executa migrações
make clean                 # Para e remove volumes
make build                 # Rebuild da imagem

# Apenas Development
make test                  # Executa testes (RSpec)
make swagger               # Gera documentação Swagger
```

## 🌍 Ambientes

### 🔧 Development

**Características:**
- ✅ Hot reload (código local montado no container)
- ✅ Cria aplicação Rails automaticamente na primeira execução
- ✅ Banco de dados local (PostgreSQL em container)
- ✅ Todas as gems instaladas
- ✅ Modo interativo disponível
- ✅ Logs detalhados

**Variáveis (.env gerado automaticamente):**
```bash
APP_CONTAINER_NAME=blog_development_app
DB_CONTAINER_NAME=blog_development_db
DB_VOLUME_NAME=blog_development_postgres_data
DOCKER_NETWORK=blog_dev_net
POSTGRES_USER=blog_db_user
POSTGRES_DB=blog_development_db
DB_HOST=db
DB_PORT=5433
RAILS_PORT=3000
```

### 🎭 Staging

**Características:**
- ✅ Assets precompilados
- ✅ Gems de development não instaladas
- ✅ Sempre em modo background
- ✅ SECRET_KEY_BASE obrigatório

**Configuração:**
```bash
# Criar .env manualmente no servidor
cat > .env << 'EOF'
APP_CONTAINER_NAME=blog_staging_app
DB_CONTAINER_NAME=blog_staging_db
DB_VOLUME_NAME=blog_staging_postgres_data
DOCKER_NETWORK=blog_staging_net
POSTGRES_USER=blog_user
POSTGRES_PASSWORD=senha_segura
POSTGRES_DB=blog_staging
SECRET_KEY_BASE=$(rails secret)
DB_HOST=db  # ou servidor externo
DB_PORT=5432
RAILS_PORT=3000
DB_INTERNAL_PORT=5432
RAILS_INTERNAL_PORT=3000
EOF

# Proteger .env
chmod 600 .env

# Subir
make up ENVIRONMENT=staging
```

### 🚀 Production

**Características:**
- ✅ Assets precompilados
- ✅ Gems de development e test não instaladas
- ✅ Deployment mode ativado
- ✅ Sempre em modo background
- ✅ SECRET_KEY_BASE obrigatório
- ✅ Otimizado para performance

**Configuração:** (igual ao staging, mas com sufixo `production`)

## 🔑 Variáveis de Ambiente

### Variáveis Base (Obrigatórias em Todos os Ambientes)

```bash
DB_HOST=db                    # Host do banco de dados
DB_PORT=5432                  # Porta externa do banco
POSTGRES_USER=usuario         # Usuário do PostgreSQL
POSTGRES_PASSWORD=senha       # Senha do PostgreSQL
POSTGRES_DB=nome_database     # Nome do banco de dados
RAILS_PORT=3000               # Porta externa do Rails
```

### Variáveis Adicionais (Production/Staging)

```bash
SECRET_KEY_BASE=chave_secreta  # Obrigatório! Gere com: rails secret
```

### Variáveis de Padronização (Automáticas)

```bash
APP_CONTAINER_NAME=projeto_env_app           # Nome do container Rails
DB_CONTAINER_NAME=projeto_env_db             # Nome do container PostgreSQL
DB_VOLUME_NAME=projeto_env_postgres_data     # Nome do volume de dados
DOCKER_NETWORK=projeto_env_network           # Nome da rede Docker
RAILS_INTERNAL_PORT=3000                     # Porta interna do container
DB_INTERNAL_PORT=5432                        # Porta interna do PostgreSQL
```

## 🔒 Segurança

### Sanitização de Nomes

O projeto **sanitiza automaticamente** nomes de projeto:

```bash
# Entrada → Saída
"Meu App"      → "meu_app"
"José's Blog"  → "joses_blog"
"API@2024"     → "api2024"
"My-Project"   → "my-project"
```

**Regras:**
- ✅ Converte para minúsculas
- ✅ Espaços viram underscore (_)
- ✅ Remove acentos e caracteres especiais
- ✅ Mantém apenas: a-z, 0-9, _, -
- ✅ Valida que começa com letra
- ✅ Máximo 50 caracteres

### Boas Práticas de Segurança

**Development:**
- ✅ `.env` commitado no Git (sem senhas reais)
- ✅ Usuário não-root nos containers
- ✅ Volumes isolados por projeto

**Staging/Production:**
- ✅ `.env` NUNCA commitado (no .gitignore)
- ✅ `chmod 600 .env` (apenas owner lê/escreve)
- ✅ SECRET_KEY_BASE único por ambiente
- ✅ Senhas fortes e diferentes
- ✅ Validação obrigatória de variáveis

### Scripts Modulares

- ✅ **envs_validation.sh** - Validação de variáveis (reutilizável)
- ✅ **run_container.sh** - Build e execução de containers
- ✅ **install_dependencies.sh** - Instalação parametrizada de gems
- ✅ **execute_migrations.sh** - Migrações com opção de verificação de BD
- ✅ **generate_database_config.sh** - Geração de database.yml

**Otimizações Aplicadas:**
- ✅ Sem git nos containers
- ✅ Limpeza de cache do apt
- ✅ Slim base image
- ✅ Bundle without em staging/prod
- ✅ Usuário não-root

**Características do ambiente de development:**
- Contém gems de desenvolvimento e teste (rspec, byebug, etc)
- Assets não precompilados (gerados dinamicamente)

**Características do ambiente de staging/production:**
- Apenas gems essenciais para runtime
- Assets precompilados durante build
- Bundle em modo deployment (mais eficiente)

### Rede e Isolamento

Cada projeto tem recursos isolados para evitar conflitos:

```
Projeto "blog":
- Containers: blog_development_app, blog_development_db
- Network: blog_dev_net
- Volume: blog_development_postgres_data

Projeto "api":
- Containers: api_development_app, api_development_db
- Network: api_dev_net
- Volume: api_development_postgres_data

✅ Zero conflitos! Múltiplos projetos no mesmo servidor.
```

## 🛠️ Customização

### Adicionar Gems

Edite `Gemfile` do projeto gerado e faça rebuild:

```bash
# No projeto
echo "gem 'devise'" >> Gemfile
make down
make up
```

### Variáveis Personalizadas

Adicione em `.env`(caso seja ambiente development edit o .env padrão dentro de base_files pois o .env na raiz do projeto é gerado automaticamente baseado nele) e passe via `environment:` no docker-compose.yml:

```yaml
environment:
  - REDIS_URL=${REDIS_URL}
```

## 📝 Notas Importantes

### Development
- ✅ Rails new executado automaticamente na primeira vez
- ✅ `.env` gerado e configurado automaticamente
- ✅ Código local montado via volume (mudanças em tempo real)
- ✅ Git no host (não no container)

### Staging/Production
- ⚠️ `.env` deve ser criado manualmente no servidor
- ⚠️ `SECRET_KEY_BASE` obrigatório
- ✅ Validação automática de variáveis obrigatórias
- ✅ Assets precompilados automaticamente

## 🎯 Roadmap

### Próximo
- 🟢 **Stack Node.js** - Template para Express/NestJS
- ⚡ Redis integration (Rails)

### Médio Prazo
- 🐍 **Stack Python/Django** - Template completo para Django
- 🗄️ Suporte a múltiplos bancos (MySQL, MongoDB)
- 🔄 CI/CD templates (GitHub Actions, GitLab CI)
- 📊 Logs centralizados

### Futuro
- 🐳 Kubernetes (k8s manifests para todas stacks)
- 📱 Geração automática de API docs
- 🔐 Secrets Manager integration
- 🌐 Load balancing e auto-scaling

## 📄 Licença

MIT License - Use livremente!
