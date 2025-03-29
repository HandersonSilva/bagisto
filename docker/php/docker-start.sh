#!/bin/bash
composer install
npm install && npm run dev

php artisan migrate --force
# php artisan db:seed --force

#service cron start
#
#/usr/bin/supervisord -c  /etc/supervisor/supervisord.conf
php-fpm -R