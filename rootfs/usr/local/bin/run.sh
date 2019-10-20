#!/bin/sh

# Default values
DB_HOST="${DB_HOST:-mariadb}"
DB_USER="${DB_USER:-flarum}"
DB_NAME="${DB_NAME:-flarum}"
DB_PORT="${DB_PORT:-3306}"
FLARUM_TITLE="${FLARUM_TITLE:-Docker-Flarum}"
DEBUG="${DEBUG:-false}"
LOG_TO_STDOUT="${LOG_TO_STDOUT:-false}"
GITHUB_TOKEN_AUTH="${GITHUB_TOKEN_AUTH:-false}"

# Required env variables
if [ -z "${DB_PASS}" ]; then
  echo "[ERROR] Mariadb database password must be set !"
  exit 1
fi

if [ -z "${FORUM_URL}" ]; then
  echo "[ERROR] Forum url must be set !"
  exit 1
fi

# Set file config for nginx and php
sed -i "s/<UPLOAD_MAX_SIZE>/${UPLOAD_MAX_SIZE}/g" /etc/nginx/nginx.conf /etc/php7/php-fpm.conf
sed -i "s/<PHP_MEMORY_LIMIT>/${PHP_MEMORY_LIMIT}/g" /etc/php7/php-fpm.conf
sed -i "s/<OPCACHE_MEMORY_LIMIT>/${OPCACHE_MEMORY_LIMIT}/g" /etc/php7/conf.d/00_opcache.ini

# Set permissions
chown -R $UID:$GID /services /var/log /var/lib/nginx

# Set log output to STDOUT if wanted (LOG_TO_STDOUT=true)
if [ "${LOG_TO_STDOUT}" = true ]; then
  echo "[INFO] Logging to stdout activated"
  chmod o+w /dev/stdout
  sed -i "s/.*error_log.*$/error_log \/dev\/stdout warn;/" /etc/nginx/nginx.conf
  sed -i "s/.*error_log.*$/error_log = \/dev\/stdout/" /etc/php7/php-fpm.conf
fi

cd /flarum/app

# add github token authentication (eg. for privates extensions)
if [ "${GITHUB_TOKEN_AUTH}" != false ]; then
  echo "[INFO] Adding github token authentication"
  composer config github-oauth.github.com "${GITHUB_TOKEN_AUTH}"
fi

# Custom repositories (eg. for privates extensions)
if [ -f '/flarum/app/extensions/composer.repositories.txt' ]; then
  while read line; do
    repository=$(echo $line | cut -d '|' -f1)
    json=$(echo $line | cut -d '|' -f2)
    echo "[INFO] Adding ${repository} composer repository"
    composer config repositories."${repository}" "${json}"
  done < /flarum/app/extensions/composer.repositories.txt
fi

# Custom vhost flarum nginx
if [ ! -e '/etc/nginx/conf.d/custom-vhost-flarum.conf' ]; then
  echo '# Example:
# fix for flagrow/sitemap (https://github.com/flagrow/sitemap)
# location = /sitemap.xml {
#   try_files $uri $uri/ /index.php?$query_string;
# }' > /etc/nginx/conf.d/custom-vhost-flarum.conf
fi

# if no installation was performed before
if [ -e '/flarum/app/public/assets/rev-manifest.json' ]; then
  echo "[INFO] Flarum already installed, init app..."

  sed -i -e "s|<DEBUG>|${DEBUG}|g" \
         -e "s|<DB_HOST>|${DB_HOST}|g" \
         -e "s|<DB_NAME>|${DB_NAME}|g" \
         -e "s|<DB_USER>|${DB_USER}|g" \
         -e "s|<DB_PASS>|${DB_PASS}|g" \
         -e "s|<DB_PREF>|${DB_PREF}|g" \
         -e "s|<FORUM_URL>|${FORUM_URL}|g" /flarum/app/config.php

  su-exec $UID:$GID php /flarum/app/flarum cache:clear

  # Composer cache dir and packages list paths
  CACHE_DIR=/flarum/app/extensions/.cache
  LIST_FILE=/flarum/app/extensions/list

  # Download extra extensions installed with composer wrapup script
  if [ -s "${LIST_FILE}" ]; then
    echo "[INFO] Install extra bundled extensions"
    while read line; do
      extension="${extension}${line} "
    done < /flarum/app/extensions/list
    cmd="composer require ${extension}"
    COMPOSER_CACHE_DIR="${CACHE_DIR}" eval $cmd
    echo "[INFO] Install extra bundled extensions: DONE."
  else
    echo "[INFO] No installed extensions"
  fi

  echo "[INFO] Init done, launch flarum..."
else
  echo "[INFO] First launch, installation..."
  rm -rf /flarum/app/config.php

  if [ -z "${FLARUM_ADMIN_USER}" ] || [ -z "${FLARUM_ADMIN_PASS}" ] || [ -z "${FLARUM_ADMIN_MAIL}" ]; then
    echo "[ERROR] User admin info of flarum must be set !"
    exit 1
  fi

  sed -i -e "s|<DEBUG>|${DEBUG}|g" \
         -e "s|<FORUM_URL>|${FORUM_URL}|g" \
         -e "s|<DB_HOST>|${DB_HOST}|g" \
         -e "s|<DB_NAME>|${DB_NAME}|g" \
         -e "s|<DB_USER>|${DB_USER}|g" \
         -e "s|<DB_PASS>|${DB_PASS}|g" \
         -e "s|<DB_PREF>|${DB_PREF}|g" \
         -e "s|<DB_PORT>|${DB_PORT}|g" \
         -e "s|<FLARUM_ADMIN_USER>|${FLARUM_ADMIN_USER}|g" \
         -e "s|<FLARUM_ADMIN_PASS>|${FLARUM_ADMIN_PASS}|g" \
         -e "s|<FLARUM_ADMIN_MAIL>|${FLARUM_ADMIN_MAIL}|g" \
         -e "s|<FLARUM_TITLE>|${FLARUM_TITLE}|g" /flarum/app/config.yml

  # Install flarum
  chown -R $UID:$GID /flarum
  su-exec $UID:$GID php /flarum/app/flarum install --file=/flarum/app/config.yml

  echo "[INFO] End of flarum installation"
fi

# Set permissions for /flarum folder
find /flarum ! -user $UID -print0 | xargs -0 -r chown $UID:$GID
find /flarum ! -group $GID -print0 | xargs -0 -r chown $UID:$GID

# RUN !
exec su-exec $UID:$GID /bin/s6-svscan /services
