FROM xataz/alpine:3.4
MAINTAINER xataz <https://github.com/xataz>
MAINTAINER hardware <https://github.com/hardware>

ARG VERSION=v0.1.0-beta.5

ENV GID=991 UID=991

RUN echo "@commuedge https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk --no-cache add nginx \
      curl \
      supervisor \
      mariadb-client \
      php7-phar@commuedge \
      php7-fpm@commuedge \
      php7-curl@commuedge \
      php7-mbstring@commuedge \
      php7-openssl@commuedge \
      php7-json@commuedge \
      php7-pdo_mysql@commuedge \
      php7-gd@commuedge \
      php7-dom@commuedge \
      php7-ctype@commuedge \
      php7-session@commuedge \
      php7-opcache@commuedge \
    && cd /tmp \
    && ln -s /usr/bin/php7 /usr/bin/php \
    && curl -s http://getcomposer.org/installer | php \
    && mv /tmp/composer.phar /usr/bin/composer \
    && chmod +x /usr/bin/composer \
    && mkdir -p /flarum/app \
    && addgroup -g ${GID} flarum && adduser -h /flarum -s /bin/sh -D -G flarum -u ${UID} flarum \
    && chown -R flarum:flarum /flarum \
    && su-exec flarum:flarum composer create-project flarum/flarum /flarum/app $VERSION --stability=beta \
    && composer clear-cache \
    && rm -rf /flarum/.composer /var/cache/apk/*

COPY config.sql /flarum/app/config.sql
COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY opcache.ini /etc/php7/conf.d/00_opcache.ini
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY startup /usr/local/bin/startup
COPY composer /usr/local/bin/composeur

RUN chmod +x /usr/local/bin/*

VOLUME /flarum/app/assets
EXPOSE 8080
CMD ["/usr/bin/tini","--","startup"]
