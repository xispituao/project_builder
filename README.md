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
> ✅ **Testado em**: Windows 10 com WSL2 usando a dist Ubuntu

### 🚀 Criando um novo projeto Rails

## 🏗️ Como Usar

### Para criar um novo projeto Rails:

1. **Clone este repositório** como template
2. **Execute `make build PROJECT_NAME=meu_projeto`**  
   - Isso irá criar uma nova pasta chamada `meu_projeto` na raiz, e dentro dela será gerada uma nova aplicação Rails já configurada.
3. **Acesse a nova pasta do projeto**  
   - `cd meu_projeto`
4. **Inicie o ambiente de desenvolvimento**  
   - `make dev` ou `make dev-interative` para não subir de forma detach
5. **Comece a desenvolver** - Tudo estará pronto! A aplicação estará rodando em http://localhost:3000

### Personalização:

- Edite os **Dockerfiles** para suas necessidades específicas
- Modifique o **database.yml.template** para configurações de banco
- Ajuste os **docker-compose** files para serviços adicionais
- Configure **variáveis de ambiente** no `.env.sample`

## 🔧 Comandos Úteis presente no makefile

```bash
# Iniciar em modo desenvolvimento
make dev

# Iniciar em modo interativo (sem detach)
make dev-interactive

# Ver logs em tempo real
make logs

# Acessar console Rails
make console

# Acessar bash do container
make bash

# Executar migrações
make migrate

# Parar containers
make down

# Limpar volumes
make clean

# Build sem cache
make build
```

### O makefile também possui esses comandos no contexto de Produção e Staging 

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

#### 🎭 **Staging** e 🚀 **Produção**
- Otimizado para performance
- Configurações de produção
- Banco de dados isolado

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


