#!/bin/sh
set -e

echo "🚀 Starting Laravel entrypoint..."

# If using SQLite in production (optional)
if [ -n "$USE_SQLITE" ]; then
    echo "📦 Ensuring SQLite file exists..."
    mkdir -p database
    touch database/database.sqlite
fi

# Run database migrations
echo "📂 Running migrations..."
php artisan migrate --force

# Only install Octane config if not already present
if [ ! -f config/octane.php ]; then
    echo "⚙️  Installing Octane with FrankenPHP..."
    php artisan octane:install --server=frankenphp
fi

# Optimize the Laravel app
# echo "🔧 Optimizing Laravel..."
# php artisan optimize

echo "✅ Entrypoint setup complete. Launching process..."
exec "$@"
