#!/bin/sh
set -e

touch database/database.sqlite
php artisan migrate --force
php artisan octane:install --server=frankenphp
php artisan optimize

exec "$@"
