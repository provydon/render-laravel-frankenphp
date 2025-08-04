# Stage 1: Composer build layer
FROM composer:latest AS composer
WORKDIR /app

# Copy composer files and install dependencies
COPY composer.* ./
RUN composer install --no-dev --no-scripts --optimize-autoloader

# Copy full app and prepare cache dirs
COPY . .
RUN mkdir -p bootstrap/cache storage/logs storage/framework/{cache,sessions,views}
RUN composer dump-autoload --optimize

# Stage 2: Runtime using FrankenPHP Alpine image
FROM dunglas/frankenphp:1-alpine AS app

# Install Supervisor and dependencies
RUN apk update --no-cache && apk add --no-cache \
    supervisor python3 py3-pip py3-setuptools \
    && install-php-extensions pcntl \
    && docker-php-ext-install pcntl

ENV PYTHONWARNINGS="ignore::UserWarning:pkg_resources"

WORKDIR /app

# Copy app from composer layer
COPY --from=composer /app/vendor ./vendor
COPY . .
COPY docker/.env.production .env

# Prepare runtime directories and set permissions
RUN mkdir -p bootstrap/cache storage/logs storage/framework/{cache,sessions,views} \
    && mkdir -p /var/log/supervisor \
    && chmod -R 775 storage bootstrap/cache public database \
    && chmod +x artisan

# Copy Supervisor config and entrypoint script
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/docker-entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Required for Render port detection
EXPOSE 80

# Health check for Render
HEALTHCHECK --interval=30s --timeout=3s CMD wget --no-verbose --spider http://localhost || exit 1

# Entrypoint and command to start Supervisor
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
