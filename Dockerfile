FROM alpine:3.11

LABEL description="Simple forum software for building great communities" \
      maintainer="Hardware <hardware@mondedie.fr>, Magicalex <magicalex@mondedie.fr>"

ARG VERSION=v0.1.0-beta.11

ENV GID=991 \
    UID=991 \
    UPLOAD_MAX_SIZE=50M \
    PHP_MEMORY_LIMIT=128M \
    OPCACHE_MEMORY_LIMIT=128 \
    DB_HOST=mariadb \
    DB_USER=flarum \
    DB_NAME=flarum \
    DB_PORT=3306 \
    FLARUM_TITLE=Docker-Flarum \
    DEBUG=false \
    LOG_TO_STDOUT=false \
    GITHUB_TOKEN_AUTH=false

RUN apk add --no-progress --no-cache \
    nginx \
    s6 \
    su-exec \
    curl \
    git \
    php7 \
    php7-fileinfo \
    php7-phar \
    php7-fpm \
    php7-curl \
    php7-mbstring \
    php7-openssl \
    php7-json \
    php7-pdo \
    php7-pdo_mysql \
    php7-mysqlnd \
    php7-zlib \
    php7-gd \
    php7-dom \
    php7-ctype \
    php7-session \
    php7-opcache \
    php7-xmlwriter \
    php7-tokenizer \
    php7-zip \
    php7-intl \
  && cd /tmp \
  && curl -s http://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && chmod +x /usr/local/bin/composer \
  && composer global require --no-progress --no-suggest -- hirak/prestissimo \
  && mkdir -p /flarum/app \
  && COMPOSER_CACHE_DIR="/tmp" composer create-project --stability=beta --no-progress -- flarum/flarum /flarum/app $VERSION \
  && composer clear-cache \
  && rm -rf /flarum/.composer /tmp/*

COPY rootfs /
RUN chmod +x /usr/local/bin/* /services/*/run /services/.s6-svscan/*
VOLUME /flarum/app/extensions /etc/nginx/conf.d
EXPOSE 8888
CMD ["/usr/local/bin/startup"]
