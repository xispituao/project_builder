# 🚀 Rails Project Builder

Template completo e automatizado para criar projetos Rails modernos com Docker e PostgreSQL, otimizado para desenvolvimento, staging e produção.

> ✅ **Status**: Projeto 100% funcional, testado e otimizado.

## ✨ Características

- 🐳 **Totalmente Dockerizado** - Ambiente consistente e isolado
- 🔧 **Auto-configuração** - Setup automático de Rails, PostgreSQL e dependências
- 🛡️ **Multi-ambiente** - Development, staging e production configurados
- 📦 **Zero Configuração Manual** - Cria projetos Rails do zero automaticamente
- 🏗️ **Template Reutilizável** - Use para múltiplos projetos sem conflitos
- 🔒 **Seguro** - Usuários não-root, sanitização de nomes, validação de variáveis
- ⚡ **Otimizado** - Imagens Docker enxutas (~430MB), cache inteligente
- 🎯 **Padronizado** - Nomes únicos para containers, volumes e networks

## 📋 Pré-requisitos

- **Docker 20.10+**
- **Docker Compose 2.0+**
- **Make**
- **Sistema**: Linux, macOS ou Windows com WSL2

> ✅ **Testado em**: Ubuntu no WSL2, Windows 10

## 🚀 Quick Start

### Criar um Novo Projeto

```bash
# Sintaxe básica
make build <nome_projeto> [caminho] [stack]

# Exemplos
make build blog                    # Cria "blog" no diretório atual
make build meu_app ~/projetos     # Cria em ~/projetos/meu_app
make build api ~/apps rails       # Especifica stack (rails é padrão)

# Com nome padrão
make build                        # Cria "my_app" no diretório atual
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
make up ENVIRONMENT=staging

# Production
make up ENVIRONMENT=production
```

## 📂 Estrutura do Projeto Gerado

```
blog/  (seu projeto)
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

## 🏗️ Arquitetura

### Fluxo de Criação

```
1. make build → makefile raiz
2. build.sh → Valida + Sanitiza + Cria estrutura
3. Copia templates → Substitui placeholders
4. Projeto pronto! ✅
```

### Fluxo de Execução (Development)

```
1. make up → makefile do projeto
2. up.sh → Copia arquivos do ambiente
3. init.sh → Gera .env + Valida variáveis
4. run_container.sh → Build + Up containers
5. entrypoint.sh → Rails new + Bundle + Migrate
6. Rails server ✅
```

### Scripts Modulares

- ✅ **envs_validation.sh** - Validação de variáveis (reutilizável)
- ✅ **run_container.sh** - Build e execução de containers
- ✅ **install_dependencies.sh** - Instalação parametrizada de gems
- ✅ **execute_migrations.sh** - Migrações com opção de verificação de BD
- ✅ **generate_database_config.sh** - Geração de database.yml

## 🐳 Docker

### Imagens Otimizadas

| Ambiente | Base | Tamanho Estimado | Gems | Assets | Otimizações |
|----------|------|------------------|------|--------|-------------|
| Development | ruby:3.4.2-slim | ~450-500MB | Todas (dev/test/prod) | Em runtime | Código via volume |
| Staging | ruby:3.4.2-slim | ~420-450MB | Sem development | Precompilados | Bundle deployment |
| Production | ruby:3.4.2-slim | ~400-430MB | Sem dev/test | Precompilados | Bundle deployment |

**Otimizações Aplicadas:**
- ✅ Sem git nos containers (~20MB economizado)
- ✅ Limpeza de cache do apt (~30MB economizado)
- ✅ Slim base image (~200MB menor que imagem completa)
- ✅ Bundle without em staging/prod (~30-50MB economizado)
- ✅ Usuário não-root (segurança)
- ✅ Multi-stage não usado (preferência por simplicidade)

**Por que Development é maior:**
- Contém gems de desenvolvimento e teste (rspec, byebug, etc)
- Assets não precompilados (gerados dinamicamente)

**Por que Production é menor:**
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

## 📦 O Que É Instalado

### Sistema (Dockerfile)
- build-essential
- postgresql-client
- libpq-dev, libyaml-dev
- curl

### Ruby/Rails (Dockerfile)
- Ruby 3.4.2
- Rails 8.0.1
- Bundler 2.5.6

### Rails (rails new)
- API mode (--api)
- PostgreSQL (--database=postgresql)
- Sem git, sem bundle inicial, sem docker

## 🔍 Troubleshooting

### Problemas Comuns

**Container não inicia:**
```bash
make logs          # Ver erros
make clean         # Limpar tudo
make up            # Tentar novamente
```

**Banco de dados com problemas:**
```bash
make clean         # Remove volumes
make up            # Recria banco
```

**Porta já em uso:**
```bash
# Editar .env e mudar RAILS_PORT
echo "RAILS_PORT=3001" >> .env
make down
make up
```

**Permissão negada (staging/production):**
```bash
chmod 600 .env
make up ENVIRONMENT=production
```

### Banco de Dados Externo (Production)

Para usar banco gerenciado (AWS RDS, etc):

```bash
# No .env do servidor
DB_HOST=db.xyz.rds.amazonaws.com
DB_PORT=5432
POSTGRES_USER=admin
POSTGRES_PASSWORD=senha_rds
POSTGRES_DB=blog_production

# Remover serviço "db" do docker-compose.yml
# Manter apenas serviço "app"
```

## 📊 Status do Projeto

| Componente | Status | Otimizado |
|------------|--------|-----------|
| **Sanitização de nomes** | ✅ | ✅ |
| **Validação de variáveis** | ✅ | ✅ |
| **Scripts modulares** | ✅ | ✅ |
| **Dockerfiles** | ✅ | ✅ |
| **docker-compose.yml** | ✅ | ✅ |
| **Multi-ambiente** | ✅ | ✅ |
| **Isolamento de projetos** | ✅ | ✅ |
| **Sem git nos containers** | ✅ | ✅ |
| **Comentários e documentação** | ✅ | ✅ |
| **Sem erros de linting** | ✅ | ✅ |

## 🛠️ Customização

### Adicionar Gems

Edite `Gemfile` do projeto gerado e faça rebuild:

```bash
# No projeto
echo "gem 'devise'" >> Gemfile
make down
make build
make up
```

### Adicionar Serviços (Redis, Sidekiq, etc)

Edite `docker-compose.yml` do projeto:

```yaml
services:
  app:
    # ...
  
  db:
    # ...
  
  redis:
    image: redis:7-alpine
    container_name: ${PROJECT_NAME}_redis
```

### Variáveis Personalizadas

Adicione em `.env` e passe via `environment:` no docker-compose.yml:

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
- ⚠️ Senhas reais (nunca commitar)
- ✅ Validação automática de variáveis obrigatórias
- ✅ Assets precompilados automaticamente

## 🎯 Roadmap

### v1.2 (Próximo)
- 🗄️ Suporte a MySQL e outros bancos
- ⚡ Template com Redis
- 📊 Logs centralizados

### v2.0 (Futuro)
- 🐳 Kubernetes (k8s manifests)
- 🔄 CI/CD templates (GitHub Actions, GitLab CI)
- 📱 Geração automática de API docs
- 🔐 Secrets Manager integration

---

## 💡 Dicas

**Múltiplos projetos no mesmo servidor:**
```bash
# Cada projeto fica isolado
make build blog ~/apps
make build api ~/apps
make build admin ~/apps

cd ~/apps/blog && make up
cd ~/apps/api && make up ENVIRONMENT=staging
cd ~/apps/admin && make up ENVIRONMENT=production

# Todos rodando simultaneamente sem conflitos! ✅
```

**GitHub/GitLab:**
```bash
# Git no host (não no container)
cd blog
git init
git add .
git commit -m "Initial commit"
git push
```

**Backup de .env:**
```bash
# Criptografado
gpg --encrypt .env > .env.gpg

# Restaurar
gpg --decrypt .env.gpg > .env
chmod 600 .env
```

---

> 🚀 **Pronto para produção!** Template completo, testado e otimizado para criar projetos Rails profissionais em minutos.

## 📄 Licença

MIT License - Use livremente!
