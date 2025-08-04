#!/bin/sh
set -e

touch database/database.sqlite
php artisan migrate --force
php artisan octane:install --server=frankenphp
chmod +x /usr/local/bin/frankenphp
php artisan optimize

exec "$@"
