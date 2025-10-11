FROM ruby:3.4.2-slim

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    postgresql-client \
    libpq-dev \
    libyaml-dev \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app /usr/local/bundle

ENV GEM_HOME=/usr/local/bundle
ENV BUNDLE_PATH=/usr/local/bundle
ENV RAILS_ENV=development
ENV RAILS_LOG_TO_STDOUT=true

RUN gem install rails -v 8.0.1 && \
    gem install bundler -v 2.5.6

WORKDIR /app

COPY . .

EXPOSE 3000

ENTRYPOINT ["sh", "./entrypoint.sh"]
CMD ["sh", "-c", "rails server -b 0.0.0.0 -p ${RAILS_INTERNAL_PORT:-3000}"]
