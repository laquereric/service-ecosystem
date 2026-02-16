#!/bin/bash
set -e

# Run database migrations on startup (storage volume is mounted at runtime)
bundle exec rails db:prepare

exec "$@"
