#!/bin/bash
composer install

php artisan migrate --force
php artisan storage:link

php-fpm