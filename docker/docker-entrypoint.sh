#!/bin/sh
set -e

echo "🚀 Starting Laravel entrypoint..."

if [ -n "$USE_SQLITE" ]; then
    echo "📦 Ensuring SQLite file exists..."
    mkdir -p database
    touch database/database.sqlite
fi

echo "📂 Running migrations..."
php artisan migrate --force

echo "✅ Entrypoint setup complete."

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
