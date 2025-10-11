FROM ruby:3.4.2-slim AS builder

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

ENV GEM_HOME=/usr/local/bundle
ENV BUNDLE_PATH=/usr/local/bundle

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

FROM ruby:3.4.2-slim

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    postgresql-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r -g 1000 app_group && \
    useradd -r -u 1000 -g app_group -m app_user

RUN mkdir -p /app /usr/local/bundle && \
    chown -R app_user:app_group /app /usr/local/bundle

ENV GEM_HOME=/usr/local/bundle
ENV BUNDLE_PATH=/usr/local/bundle
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

COPY --from=builder --chown=app_user:app_group /usr/local/bundle /usr/local/bundle

USER app_user
WORKDIR /app

COPY --chown=app_user:app_group . .

EXPOSE 3000

ENTRYPOINT ["sh", "./entrypoint.sh"]
CMD ["sh", "-c", "rails server -b 0.0.0.0 -p ${RAILS_INTERNAL_PORT:-3000}"]
