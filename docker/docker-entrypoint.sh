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

# Optional: optimize Laravel (disabled to avoid caching view issues in deploys)
# echo "🔧 Optimizing Laravel..."
# php artisan optimize

echo "✅ Entrypoint setup complete. Starting Supervisor..."

# Start Supervisor which will launch frankenphp + queue workers
exec "$@"
