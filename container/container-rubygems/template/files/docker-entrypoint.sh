#!/bin/bash -e

# Prepare database if running rails server
if [ "${@: -2:1}" == "bin/rails" ] && [ "${@: -1:1}" == "server" ]; then
  bin/rails db:prepare
fi

exec "${@}"
