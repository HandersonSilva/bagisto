#!/bin/bash

if [ ! -e .env ] && [ -e .env.example ]
then
  envsubst < .env.example > .env
  php artisan key:generate
fi

php artisan migrate --force
php artisan db:seed --force

touch /var/www/html/storage/logs/laravel.log && chmod -R 777 /var/www/html/storage/logs/laravel.log

/usr/bin/supervisord -c  /etc/supervisor/supervisord.conf