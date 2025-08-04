FROM composer:latest AS composer
WORKDIR /app
COPY composer.* ./
RUN composer install --no-dev --no-scripts --optimize-autoloader
COPY . .
RUN mkdir -p bootstrap/cache storage/logs storage/framework/{cache,sessions,views}
RUN composer dump-autoload --optimize

FROM dunglas/frankenphp:1-alpine AS app

RUN apk update --no-cache && apk add --no-cache \
    supervisor python3 py3-pip py3-setuptools \
    && install-php-extensions pcntl \
    && docker-php-ext-install pcntl

ENV PYTHONWARNINGS="ignore::UserWarning:pkg_resources"

WORKDIR /app

COPY --from=composer /app/vendor ./vendor
COPY . .
COPY docker/.env.production .env

RUN mkdir -p bootstrap/cache storage/logs storage/framework/{cache,sessions,views} \
    && mkdir -p /var/log/supervisor \
    && chmod -R 775 storage bootstrap/cache public database \
    && chmod +x artisan

COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/docker-entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# ✅ Render requires a port exposed
EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s CMD wget --no-verbose --spider http://localhost || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
