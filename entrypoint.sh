#!/bin/bash
set -e

if [[ $@ == "server" ]]; then
  exec bundle exec rackup config.ru -p 3000 -o 0.0.0.0
elif [[ $@ == "cli" ]]; then
  exec irb -r ./lib/cli.rb
else
  exec "$@"
fi
