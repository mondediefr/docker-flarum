FROM xataz/alpine:3.4
MAINTAINER xataz <https://github.com/xataz>
MAINTAINER hardware <https://github.com/hardware>

ENV GID=991 UID=991

RUN echo "@testing https://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && export BUILD_DEPS="git" \
    && apk --no-cache add nginx \
            curl \
            php7-phar@testing \
            supervisor \
            php7-fpm@testing \
            php7-curl@testing \
            php7-mbstring@testing \
            php7-openssl@testing \
            php7-json@testing \
            php7-pdo_mysql@testing \
            php7-gd@testing \
            php7-dom@testing \
            ${BUILD_DEPS} \
    && cd /tmp \
    && ln -s /usr/bin/php7 /usr/bin/php \
    && curl -s http://getcomposer.org/installer | php \
    && mv /tmp/composer.phar /usr/bin/composer \
    && chmod +x /usr/bin/composer \
    && mkdir /flarum \
    && addgroup -g ${GID} flarum && adduser -h /flarum -s /bin/sh -D -G flarum -u ${UID} flarum \
    && chown flarum:flarum /flarum \
    && su-exec flarum:flarum composer create-project flarum/flarum /flarum/app --stability=beta \
    && composer clear-cache \
    && rm -rf /flarum/.composer/cache/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php.ini /etc/php7/php.ini
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY startup /usr/local/bin/startup
RUN chmod +x /usr/local/bin/startup

EXPOSE 8080
CMD ["/usr/bin/tini","--","startup"]
