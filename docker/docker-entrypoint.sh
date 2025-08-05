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

echo "✅ Entrypoint setup complete. Starting FrankenPHP manually..."

PORT="${SERVER_NAME##*:}"
/usr/local/bin/frankenphp -S 0.0.0.0:${PORT:-8000} public/index.php &

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
