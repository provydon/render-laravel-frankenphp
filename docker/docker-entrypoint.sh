#!/bin/sh
set -e

echo "🚀 Starting Laravel entrypoint..."

# Optional: support SQLite
if [ -n "$USE_SQLITE" ]; then
    echo "📦 Ensuring SQLite file exists..."
    mkdir -p database
    touch database/database.sqlite
fi

# Run database migrations
echo "📂 Running migrations..."
php artisan migrate --force

echo "✅ Entrypoint setup complete. Starting FrankenPHP manually..."

# Start FrankenPHP manually instead of via supervisor
/usr/local/bin/frankenphp -S 0.0.0.0:80 public/index.php &

# Start queue worker via Supervisor (still useful for background task management)
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
