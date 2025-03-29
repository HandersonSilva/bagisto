#!/bin/bash
php artisan view:clear
php artisan config:clear
php artisan route:clear
php artisan optimize:clear
#php artisan config:cache

/usr/bin/supervisord -c  /etc/supervisor/supervisord.conf