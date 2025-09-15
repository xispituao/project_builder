# 🚀 Rails Project Builder

Um template completo e **testado** para criar projetos Rails modernos com Docker e PostgreSQL, configurado para desenvolvimento, staging e produção.

> ✅ **Status**: Projeto 100% funcional e testado.

## ✨ Características

- 🐳 **Dockerizado** - Ambiente consistente em qualquer máquina
- 🔧 **Auto-configuração** - Setup automático do banco de dados PostgreSQL
- 🛡️ **Multi-ambiente** - Desenvolvimento, staging e produção
- 📦 **Zero-config** - Cria projetos Rails do zero sem configuração manual
- 🏗️ **Template Reutilizável** - Use como base para novos projetos Rails
- ✅ **Testado e Validado** - Todos os componentes testados e funcionando
- 🚀 **Servidor Virgem** - Funciona em qualquer servidor limpo

## 🏃‍♂️ Quick Start

### Pré-requisitos

- **Docker 20.10+** e **Docker Compose 2.0+**
- **Sistema operacional**: Linux, macOS ou Windows (Docker Desktop)
- **Git** (para clonar o repositório)

> 💡 **Windows**: Funciona nativamente com Docker Desktop. WSL2 é opcional mas recomendado para melhor performance.
> 
> ✅ **Testado em**: Windows 10 com WSL2

### 🚀 Criando um novo projeto Rails

#### **Desenvolvimento Local:**
```bash
# Clone o template
git clone <repository-url>
cd rails_project_builder

# Crie um projeto para desenvolvimento
make build PROJECT_NAME=meu_projeto
# ou
make build-dev PROJECT_NAME=meu_projeto

# Acesse sua aplicação
cd meu_projeto
make dev

# ✅ Sua aplicação Rails estará rodando em http://localhost:3000
```

#### **Staging/Produção:**
```bash
# Para staging (configure as variáveis de ambiente primeiro)
export POSTGRES_PASSWORD="sua_senha_staging"
export POSTGRES_USER="seu_usuario"
export POSTGRES_DB="seu_banco_staging"
export SECRET_KEY_BASE="sua_chave_secreta"

make build-staging PROJECT_NAME=meu_projeto_staging

# Para produção (configure as variáveis de ambiente primeiro)
export POSTGRES_PASSWORD="sua_senha_producao"
export POSTGRES_USER="seu_usuario"
export POSTGRES_DB="seu_banco_producao"
export SECRET_KEY_BASE="sua_chave_secreta"

make build-prod PROJECT_NAME=meu_projeto_production
```

#### **GitHub Actions:**
```yaml
# .github/workflows/deploy.yml
- name: Build for Staging
  run: make build-staging PROJECT_NAME=my_app
  env:
    POSTGRES_PASSWORD: ${{ secrets.STAGING_DB_PASSWORD }}
    # ... outras variáveis
```

> ⚠️ **Nota**: A integração com GitHub Actions ainda está sendo desenvolvida e otimizada. Use com cuidado em produção.

> 💡 **Dica**: O template funciona em qualquer ambiente - desenvolvimento, staging ou produção!

## 🏗️ Como Usar como Template

### Para criar um novo projeto Rails:

1. **Clone este repositório** como template
2. **Renomeie a pasta** para o nome do seu projeto
3. **Execute `make dev`** - O sistema criará automaticamente:
   - Nova aplicação Rails
   - Configuração do PostgreSQL
   - Estrutura Docker completa
   - Variáveis de ambiente
4. **Comece a desenvolver** - Tudo estará pronto!

### Personalização:

- Edite os **Dockerfiles** para suas necessidades específicas
- Modifique o **database.yml.template** para configurações de banco
- Ajuste os **docker-compose** files para serviços adicionais
- Configure **variáveis de ambiente** no `.env.sample`

## 🔧 Comandos Úteis

### Desenvolvimento

```bash
# Iniciar em modo desenvolvimento
make dev

# Iniciar em modo interativo (sem detach)
make dev-interactive

# Ver logs em tempo real
make logs

# Acessar console Rails
make console

# Executar migrações
make migrate

# Parar containers
make down

# Limpar volumes
make clean

# Build sem cache
make build
```

### Produção e Staging

```bash
# Produção
make prod
make logs-prod
make console-prod
make migrate-prod
make down-prod
make clean-prod

# Staging
make staging
make logs-staging
make console-staging
make migrate-staging
make down-staging
make clean-staging
```

## 📁 Estrutura do Projeto

```
├── 🐳 Dockerfiles
│   ├── Dockerfile.development
│   ├── Dockerfile.production
│   └── Dockerfile.staging
├── 📋 Docker Compose
│   ├── docker-compose.development.yml
│   ├── docker-compose.production.yml
│   └── docker-compose.staging.yml
├── 🔧 Scripts
│   ├── entrypoint.sh          # Script de inicialização
│   ├── init.sh               # Setup do ambiente
│   ├── build.sh              # Script de build
│   ├── makefile              # Comandos simplificados
│   └── generate_database_config.sh
├── ⚙️ Configuração
│   ├── .env.sample           # Template de variáveis
│   ├── database.yml.template # Template do banco
│   └── .dockerignore
└── 📝 Documentação
    └── README.md
```

## 🎯 Como Funciona

### 🔄 Fluxo de Criação do Projeto

1. **Detecção automática** - O sistema detecta se é a primeira execução
2. **Rails new** - Cria uma nova aplicação Rails com configurações otimizadas
3. **Preservação** - Mantém arquivos de configuração personalizados do template
4. **Setup do banco** - Configura automaticamente o PostgreSQL
5. **Inicialização** - Executa migrações e inicia a aplicação

### 🛠️ Configuração Automática

- ✅ **Banco de dados** - PostgreSQL configurado automaticamente
- ✅ **Variáveis de ambiente** - Geradas a partir do template
- ✅ **Dependências** - Bundle install automático
- ✅ **Migrações** - Executadas na primeira execução
- ✅ **Docker** - Ambiente containerizado pronto para uso

### 📦 Dependências Incluídas

O template inclui automaticamente:
- **Ruby 3.4.2** - Runtime principal
- **Rails 8.0.1** - Framework web
- **PostgreSQL 17.6** - Banco de dados principal
- **Docker & Docker Compose** - Containerização
- **Build Tools** - Compiladores e bibliotecas necessárias (build-essential)
- **Git** - Controle de versão
- **Todas as gems nativas** - Compilação automática garantida

## 🌍 Ambientes Suportados

#### 🧪 **Desenvolvimento**
- Hot reload ativado
- Logs detalhados
- Banco de dados local

#### 🎭 **Staging**
- Ambiente de testes
- Configurações de produção
- Banco de dados isolado

#### 🚀 **Produção**
- Otimizado para performance
- Configurações de segurança
- Banco de dados persistente

## 🔍 Troubleshooting

### Problemas comuns

**🐳 Container não inicia**
```bash
# Verificar logs
make logs

# Rebuild completo
make clean
make build
make dev
```

**🗄️ Problemas de banco**
```bash
# Reset do banco
make clean
make dev
```

**📦 Dependências**
```bash
# Limpar cache do bundle
make console
# Dentro do console Rails:
bundle clean --force
bundle install
```

**🔧 Problemas de build**
```bash
# Limpar cache do Docker
docker system prune -a

# Rebuild sem cache
make clean
make build
```

### Status de Qualidade

| Componente | Status | Testado |
|------------|--------|---------|
| **Dockerfiles** | ✅ OK | ✅ Sim |
| **Scripts Bash** | ✅ OK | ✅ Sim |
| **Docker Compose** | ✅ OK | ✅ Sim |
| **Makefile** | ✅ OK | ✅ Sim |
| **Multi-ambiente** | ✅ OK | ✅ Sim |
| **Servidor Virgem** | ✅ OK | ✅ Sim |
| **GitHub Actions** | 🔄 Em Dev | ⚠️ Parcial |

## 📋 Changelog

### v1.1 (Atual)
- ✅ Corrigidos problemas críticos nos Dockerfiles
- ✅ Corrigido fluxo de execução no init.sh
- ✅ Adicionado build-essential para staging/production
- ✅ Testes completos aplicados
- ✅ Documentação atualizada
- 🔄 GitHub Actions em desenvolvimento e otimização

### v1.0 (Inicial)
- 🎉 Lançamento inicial
- 🐳 Configuração Docker completa
- 🛡️ Suporte multi-ambiente
- 🔧 Auto-configuração Rails

## 🚀 O que ainda está por vir

### Funcionalidades Planejadas

- 🐳 **Kubernetes** - Integração completa com Kubernetes para orquestração de containers
- 🗄️ **Banco de Dados Dinâmico** - Suporte para PostgreSQL, MySQL, SQLite e outros bancos
- ⚡ **Redis** - Integração com Redis para cache e sessões
- 🔄 **GitHub Actions** - Melhorias e otimizações na integração CI/CD
- 📊 **Monitoramento** - Integração com ferramentas de monitoramento e logs
- 🔐 **Segurança** - Melhorias de segurança e autenticação
- 📱 **API Documentation** - Geração automática de documentação de API
- 🧪 **Testing** - Suporte aprimorado para testes automatizados
- 🌐 **Load Balancing** - Configurações para balanceamento de carga
- 📈 **Scaling** - Ferramentas para escalabilidade horizontal e vertical

### Roadmap

**v1.2 (Próxima)**
- 🐳 Integração Kubernetes
- 🗄️ Suporte a múltiplos bancos de dados
- ⚡ Integração Redis

**v1.3 (Futuro)**
- 🔄 GitHub Actions otimizado
- 📊 Monitoramento e logs
- 🔐 Melhorias de segurança

**v2.0 (Longo Prazo)**
- 📱 API Documentation automática
- 🧪 Testing avançado
- 🌐 Load balancing
- 📈 Auto-scaling

---

> 🚀 **Pronto para usar!** Este template está 100% funcional e testado. Crie seu projeto Rails em minutos!


