FROM wonderfall/nginx-php

LABEL description "Next-generation forum software that makes online discussion fun" \
      maintainer="Hardware <hardware@mondedie.fr>, Magicalex <magicalex@mondedie.fr>"

ARG VERSION=v0.1.0-beta.6

ENV GID=991 UID=991 UPLOAD_MAX_SIZE=50M MEMORY_LIMIT=128M

RUN apk add -U curl \
 && cd /tmp \
 && curl -s http://getcomposer.org/installer | php \
 && mv /tmp/composer.phar /usr/bin/composer \
 && chmod +x /usr/bin/composer \
 && mkdir -p /flarum/app \
 && chown -R $UID:$GID /flarum \
 && COMPOSER_CACHE_DIR="/tmp" su-exec $UID:$GID composer create-project flarum/flarum /flarum/app $VERSION --stability=beta \
 # ----- Zend stratigility deprecated message temporary fix -----
 # https://github.com/flarum/core/issues/1065
 && rm -f /flarum/app/composer.lock \
 && COMPOSER_CACHE_DIR="/tmp" su-exec $UID:$GID composer require zendframework/zend-stratigility:1.2.* -d /flarum/app \
 # --------------------------------------------------------------
 && composer clear-cache \
 && rm -rf /flarum/.composer /var/cache/apk/*

COPY rootfs /
RUN chmod +x /usr/local/bin/* /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*
VOLUME /flarum/app/assets /flarum/app/extensions
EXPOSE 8888
CMD ["run.sh"]
