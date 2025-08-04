#!/bin/sh
set -e

echo "🚀 Starting Laravel entrypoint..."

# Optional: support SQLite-based deployments
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

# Optional: enable this if you want config/route/view caching
# echo "🔧 Optimizing Laravel..."
# php artisan optimize

echo "✅ Entrypoint setup complete. Starting web server..."

# ⬇️ Start Laravel Octane using FrankenPHP directly
exec php artisan octane:start --server=frankenphp --host=0.0.0.0 --port=80
