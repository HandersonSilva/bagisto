#!/bin/bash

# Replace environment variables in configuration files
touch .env && env > .env

php artisan migrate --force
php artisan db:seed --force

touch /var/www/html/storage/logs/laravel.log && chmod -R 777 /var/www/html/storage/logs/laravel.log

/usr/bin/supervisord -c  /etc/supervisor/supervisord.conf