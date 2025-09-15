# Análise de Variáveis de Ambiente - Avantsoft

## Problemas Identificados

### 1. Valores Hardcoded nos Docker Compose

**Problema**: A porta do banco de dados está hardcoded como `5432` em todos os arquivos docker-compose.

**Arquivos afetados**:
- `docker-compose.development.yml` (linha 13)
- `docker-compose.staging.yml` (linha 12) 
- `docker-compose.production.yml` (linha 12)

**Código problemático**:
```yaml
environment:
  - DB_PORT=5432  # ❌ Hardcoded
```

**Deveria ser**:
```yaml
environment:
  - DB_PORT=${DB_PORT}  # ✅ Usando variável
```

### 2. Inconsistência na Porta do Banco

**Problema**: Conflito entre as portas definidas em diferentes lugares.

- `init.sh` (linha 20): `DB_PORT=5435` (desenvolvimento)
- Docker-compose: `DB_PORT=5432` (hardcoded)
- Mapeamento: `"${DB_PORT}:5432"` (variável para host, hardcoded para container)

### 3. Inconsistência entre Arquivos .env

**Problema**: Diferenças entre `.env.development` e `.env.sample`.

**Diferenças encontradas**:
- `.env.development`: `DB_PORT=5435`
- `.env.sample`: `DB_PORT=5433`

**Impacto**: Confusão sobre qual porta usar para desenvolvimento.

### 4. Diferenças entre Ambientes

**Development**:
- ✅ Tem `SECRET_KEY_BASE` (no .env.development)
- ✅ Usa arquivo `.env.development`
- ❌ `DB_PORT` hardcoded nos docker-compose

**Staging/Production**:
- ✅ Têm `SECRET_KEY_BASE`
- ✅ Usam variáveis de ambiente do sistema
- ❌ `DB_PORT` hardcoded

## Recomendações

### 1. Padronizar Uso de Variáveis
- Substituir todos os valores hardcoded por variáveis de ambiente
- Usar `${DB_PORT}` em vez de `5432` nos docker-compose

### 2. Padronizar Arquivos .env
- Unificar as portas entre `.env.development` e `.env.sample`
- Definir qual porta usar como padrão (5433 ou 5435)

### 3. Unificar Configurações
- ✅ `SECRET_KEY_BASE` já existe no .env.development
- Padronizar as portas entre todos os ambientes

### 4. Melhorar Consistência
- Usar a mesma porta interna do PostgreSQL (5432) em todos os ambientes
- Permitir apenas a porta externa ser configurável via variável

## Tarefas Pendentes

- [ ] Corrigir valores hardcoded nos docker-compose
- [ ] Unificar portas entre .env.development e .env.sample
- [ ] Padronizar configurações entre ambientes
- [ ] Testar todas as configurações após correções

## Review

### Resumo das Mudanças Realizadas

1. **Correção do Problema do Gemfile**: Resolvido erro "Could not locate Gemfile or .bundle/ directory"
2. **Modificação do init.sh**: Implementada lógica para gerar .env.development apenas se não existir
3. **Correção do entrypoint.sh**: Melhorada lógica de inicialização do Rails para verificar existência do Gemfile
4. **Teste da Solução**: Container funcionando corretamente com servidor Rails ativo

### Detalhes das Correções

#### 1. Modificação do init.sh
- **Antes**: Criava .env.development com configurações hardcoded
- **Depois**: Gera .env.development a partir do .env.sample apenas se não existir
- **Benefício**: Preserva configurações existentes e usa template quando necessário

#### 2. Correção do entrypoint.sh
- **Problema**: Tentava executar `bundle install` sem verificar se Gemfile existia
- **Solução**: Alterada verificação de `! -d config` para `! -f Gemfile`
- **Resultado**: Rails é inicializado corretamente antes de comandos bundle

#### 3. Teste de Funcionamento
- ✅ Container inicia sem erros
- ✅ Rails é inicializado automaticamente
- ✅ Dependências são instaladas via bundle install
- ✅ Servidor responde na porta 3000
- ✅ Banco de dados é configurado automaticamente

### Impacto das Correções

- ✅ Problema do Gemfile resolvido
- ✅ Inicialização automática do Rails funcionando
- ✅ Configuração de ambiente mais robusta
- ✅ Container funcional para desenvolvimento
- ✅ Preservação de configurações existentes

### Correções de Segurança Implementadas

#### 4. Proteção de Dados Sensíveis nos Logs
- **Problema**: Scripts expunham senhas e dados sensíveis em logs
- **Solução**: Implementada verificação de ambiente para logs detalhados
- **Resultado**: 
  - ✅ Development: Mostra informações detalhadas (incluindo senhas para debug)
  - ✅ Production/Staging: Logs seguros sem exposição de dados sensíveis

#### 5. Modificação do generate_database_config.sh
- **Antes**: Sempre mostrava POSTGRES_PASSWORD e outros dados sensíveis
- **Depois**: Mostra dados detalhados apenas em RAILS_ENV=development
- **Teste**: Confirmado que em produção apenas mostra "Configuração do banco aplicada com sucesso"

#### 6. Modificação do entrypoint.sh
- **Antes**: Sempre mostrava comando completo executado
- **Depois**: Mostra comando detalhado apenas em desenvolvimento
- **Resultado**: Logs mais seguros em produção/staging

#### 7. Preservação de Arquivos Git e Docker
- **Problema**: `rails new --force` substituía arquivos importantes do projeto
- **Arquivos afetados**: README.md, .gitignore, .gitattributes, .dockerignore, .dockerignore.runtime
- **Solução**: Implementada preservação completa de arquivos importantes antes do `rails new`
- **Recuperação**: Restaurados arquivos originais do commit 1e486f2
- **Arquivos preservados**: 
  - README.md (documentação do projeto)
  - .gitignore (configurações de ignore personalizadas)
  - .gitattributes (configurações de atributos git)
  - .dockerignore (configurações de ignore para Docker)
  - .dockerignore.runtime (configurações específicas para runtime)
- **Teste**: Confirmado que todos os arquivos originais são restaurados após inicialização do Rails

#### 8. Correção Final do Problema do Gemfile
- **Problema**: Container falhava com "Could not locate Gemfile or .bundle/ directory"
- **Causa**: Lógica duplicada e incorreta para verificar se gems estavam instaladas
- **Solução**: Simplificada lógica de inicialização:
  - Se não há Gemfile: inicializa Rails completo com preservação de arquivos
  - Se não há .bundle ou Gemfile.lock: apenas instala dependências
  - Configuração do banco sempre executada após instalação
- **Resultado**: 
  - ✅ Container inicia sem erros
  - ✅ Dependências são instaladas corretamente
  - ✅ Servidor Rails funciona na porta 3000
  - ✅ Todos os arquivos importantes são preservados

### Tarefas Pendentes (Análise Anterior)

- [ ] Corrigir valores hardcoded nos docker-compose
- [ ] Unificar portas entre .env.development (5435) e .env.sample (5433)
- [ ] Padronizar configurações entre ambientes
- [ ] Testar todas as configurações após correções
