FROM ruby:3.4-slim

RUN apt-get update && apt-get install -y \
  build-essential \
  git \
  pkg-config \
  libsqlite3-dev \
  libyaml-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4

COPY . .

# Precompile assets at build time (does not need DB)
RUN SECRET_KEY_BASE=placeholder RAILS_ENV=production bundle exec rails assets:precompile

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=1
ENV RAILS_LOG_TO_STDOUT=1

EXPOSE 3000

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
