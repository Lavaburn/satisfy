FROM php:8.4-fpm-alpine

# Dependencies
RUN apk add --no-cache git unzip libzip && \
    apk add --no-cache --virtual .build-deps libzip-dev && \
    docker-php-ext-install zip && \
    apk del .build-deps
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

ENV APP_ENV=prod
ENV APP_DEBUG=0

# Application
WORKDIR /var/www/html
COPY . /var/www/html

RUN chmod +x /var/www/html/init.sh

# Install application dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction && \
    rm -f config/parameters.yml

# Fix permissions
RUN mkdir -p /root/.composer && chmod 755 /root && chmod 777 /root/.composer

WORKDIR /var/www/html/public
CMD ["/usr/local/sbin/php-fpm", "-F"]
