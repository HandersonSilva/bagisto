#!/bin/bash

# Replace environment variables in configuration files
touch .env && grep -E "^($(cut -d= -f1 .env.example | paste -sd '|' -))=" <(env) > .env

php artisan migrate --force

touch /var/www/html/storage/logs/laravel.log && chmod -R 777 /var/www/html/storage/logs/laravel.log

/usr/bin/supervisord -c  /etc/supervisor/supervisord.conf