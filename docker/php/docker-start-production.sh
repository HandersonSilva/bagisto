#!/bin/bash

# Replace environment variables in configuration files
touch .env && grep -E "^($(cut -d= -f1 .env.example | paste -sd '|' -))=" <(env) > .env

php artisan migrate --force

supervisord