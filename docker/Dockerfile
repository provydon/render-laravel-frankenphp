FROM composer:latest AS composer
WORKDIR /app
COPY composer.* ./
RUN composer install --no-dev --no-scripts --optimize-autoloader
COPY . .
RUN mkdir -p bootstrap/cache storage/logs storage/framework/cache storage/framework/sessions storage/framework/views
RUN composer dump-autoload --optimize

FROM dunglas/frankenphp:1-alpine AS app

RUN apk update --no-cache && \
    apk add --no-cache supervisor python3 py3-pip py3-setuptools || \
    (sleep 5 && apk update --no-cache && apk add --no-cache supervisor python3 py3-pip py3-setuptools)

ENV PYTHONWARNINGS="ignore::UserWarning:pkg_resources"

RUN install-php-extensions pcntl
RUN docker-php-ext-install pcntl

WORKDIR /app

COPY --from=composer /app/vendor ./vendor
COPY . .
COPY docker/.env .env

RUN mkdir -p bootstrap/cache storage/logs storage/framework/cache storage/framework/sessions storage/framework/views
RUN mkdir -p /var/log/supervisor
RUN chmod -R 775 storage bootstrap/cache public database && \
    chmod +x artisan

COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/docker-entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
