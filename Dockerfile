# Stage 1: Builder stage (para desenvolvimento e construção)
FROM ruby:3.4.2-slim AS builder

# Instala dependências de build de forma segura
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    postgresql-client \
    libpq-dev \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs=20.17.0-1nodesource1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*

# Cria usuário e grupo não-root com UID/GID fixo para consistência
RUN groupadd -r -g 1000 avantsoft && \
    useradd -r -u 1000 -g avantsoft avantsoft

# Cria diretório de trabalho com permissões corretas
RUN mkdir -p /avantsoft_app && \
    chown avantsoft:avantsoft /avantsoft_app

WORKDIR /avantsoft_app

# Configura variáveis de ambiente
ENV GEM_HOME=/usr/local/bundle

# Configura permissões seguras para bundle
RUN mkdir -p $GEM_HOME && \
    chown avantsoft:avantsoft $GEM_HOME && \
    chmod 1777 $GEM_HOME

USER avantsoft

# Instala Rails e dependências
RUN gem install rails -v 8.0.1 && \
    gem install bundler -v 2.5.6

# Stage 2: Runtime stage (leve para produção/staging)
FROM ruby:3.4.2-slim AS runtime

# Instala apenas dependências essenciais de runtime
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    postgresql-client \
    curl \
    tzdata \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs=20.17.0-1nodesource1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*

# Cria usuário e grupo com mesmo UID/GID do builder
RUN groupadd -r -g 1000 avantsoft && \
    useradd -r -u 1000 -g avantsoft avantsoft

# Cria diretório de trabalho
RUN mkdir -p /avantsoft_app && \
    chown avantsoft:avantsoft /avantsoft_app

WORKDIR /avantsoft_app

# Configura variáveis de ambiente
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_APP_CONFIG=/avantsoft_app/.bundle \
    GEM_HOME=/usr/local/bundle \
    PATH=/avantsoft_app/bin:/usr/local/bundle/bin:$PATH

# Configura permissões seguras
RUN mkdir -p $GEM_HOME && \
    chown avantsoft:avantsoft $GEM_HOME && \
    chmod 1777 $GEM_HOME

USER avantsoft

# Copia apenas as gems do builder (camada otimizada)
COPY --from=builder --chown=avantsoft:avantsoft /usr/local/bundle /usr/local/bundle

# Expõe porta
EXPOSE 3000

# Entrypoint para configurações finais
COPY --chown=avantsoft:avantsoft entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
