# Stage 1: Composer build layer
FROM composer:latest AS composer
WORKDIR /app
COPY composer.* ./
RUN composer install --no-dev --no-scripts --optimize-autoloader
COPY . .
RUN mkdir -p bootstrap/cache storage/logs storage/framework/{cache,sessions,views}
RUN composer dump-autoload --optimize

# Stage 2: Runtime using FrankenPHP Alpine image
FROM dunglas/frankenphp:1-alpine AS app

RUN apk update --no-cache && apk add --no-cache \
    supervisor python3 py3-pip py3-setuptools \
    && install-php-extensions pcntl \
    && docker-php-ext-install pcntl

ENV PYTHONWARNINGS="ignore::UserWarning:pkg_resources"
ENV SERVER_NAME=:8000

WORKDIR /app
COPY --from=composer /app /app

ARG USER=appuser
RUN adduser -D ${USER} \
    && setcap -r /usr/local/bin/frankenphp \
    && mkdir -p /var/log/supervisor \
    && chmod -R 775 /app/storage /app/bootstrap/cache /app/public /app/database \
    && chown -R ${USER}:${USER} /data/caddy /config/caddy /app

USER ${USER}

COPY docker/.env.production .env
RUN chmod +x artisan

COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/docker-entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s CMD wget --no-verbose --spider http://localhost:8000 || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
