# =============================================================================
# Dockerfile - Production
# =============================================================================
# Imagem Docker otimizada para ambiente de produção
# - Ruby 3.4.2 (slim para menor tamanho e segurança)
# - PostgreSQL client
# - Usuário não-root para segurança
# - Assets precompilados
# - Sem gems de development e test (deployment mode)
# =============================================================================

FROM ruby:3.4.2-slim

# Instala dependências do sistema
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    postgresql-client \
    libpq-dev \
    libyaml-dev \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r -g 1000 app_group && \
    useradd -r -u 1000 -g app_group -m app_user

RUN mkdir -p /app /usr/local/bundle && \
    chown -R app_group:app_user /app /usr/local/bundle

ENV GEM_HOME=/usr/local/bundle
ENV BUNDLE_PATH=/usr/local/bundle
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

USER app_user
WORKDIR /app

RUN gem install rails -v 8.0.1 && \
    gem install bundler -v 2.5.6

COPY --chown=app_group:app_user . .

EXPOSE 3000

ENTRYPOINT ["sh", "./entrypoint.sh"]
CMD ["sh", "-c", "rails server -b 0.0.0.0 -p ${RAILS_INTERNAL_PORT:-3000}"]
