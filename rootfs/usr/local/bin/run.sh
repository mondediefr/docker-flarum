#!/bin/sh

# Env variables
export DB_HOST
export DB_USER
export DB_NAME
export DEBUG
export DO_CHMOD

# Default values
DB_HOST=${DB_HOST:-mariadb}
DB_USER=${DB_USER:-flarum}
DB_NAME=${DB_NAME:-flarum}
DEBUG=${DEBUG:-false}
LOG_TO_STDOUT=${LOG_TO_STDOUT:-false}
DO_CHMOD=${DO_CHMOD:-true}

# Required env variables
if [ -z "$DB_PASS" ]; then
  echo "[ERROR] Mariadb database password must be set !"
  exit 1
fi

if [ -z "$FORUM_URL" ]; then
  echo "[ERROR] Forum url must be set !"
  exit 1
fi

sed -i "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /etc/nginx/nginx.conf /etc/php7/php-fpm.conf
sed -i "s/<PHP_MEMORY_LIMIT>/$PHP_MEMORY_LIMIT/g" /etc/php7/php-fpm.conf
sed -i "s/<OPCACHE_MEMORY_LIMIT>/$OPCACHE_MEMORY_LIMIT/g" /etc/php7/conf.d/00_opcache.ini

# Set permissions
if [ "$DO_CHMOD" = true ]; then
  chown -R $UID:$GID /flarum /services /var/log /var/lib/nginx
fi

cd /flarum/app

# Set log output to STDOUT if wanted (LOG_TO_STDOUT=true)
if [ "$LOG_TO_STDOUT" = true ]; then
  echo "[INFO] Logging to stdout activated"
  chmod o+w /dev/stdout
  sed -i "s/.*error_log.*$/error_log \/dev\/stdout warn;/" /etc/nginx/nginx.conf
  sed -i "s/.*error_log.*$/error_log = \/dev\/stdout/" /etc/php7/php-fpm.conf
fi

# Disable custom errors pages if debug mode is enabled
if [ "$DEBUG" = true ]; then
  echo "[INFO] Debug mode enabled"
  sed -i '/error_page/ s/^/#/' /etc/nginx/nginx.conf
fi

# Custom HTTP errors pages
if [ -d 'assets/errors' ]; then
  echo "[INFO] Found custom errors pages"
  rm -rf vendor/flarum/core/error/*
  ln -s /flarum/app/assets/errors/* vendor/flarum/core/error
fi

# Custom repositories (eg. for privates extensions)
if [ -f 'extensions/composer.repositories.txt' ]; then
  while read line; do
    repository=$(echo $line | cut -d '|' -f1)
    json=$(echo $line | cut -d '|' -f2)
    echo "[INFO] Adding ${repository} composer repository"
    composer config repositories.${repository} "${json}"
  done < extensions/composer.repositories.txt
fi

# if no installation was performed before
if [ -e 'assets/rev-manifest.json' ]; then

  echo "[INFO] Flarum already installed, init app..."

  sed -i -e "s|<DEBUG>|${DEBUG}|g" \
         -e "s|<DB_HOST>|${DB_HOST}|g" \
         -e "s|<DB_NAME>|${DB_NAME}|g" \
         -e "s|<DB_USER>|${DB_USER}|g" \
         -e "s|<DB_PASS>|${DB_PASS}|g" \
         -e "s|<DB_PREF>|${DB_PREF}|g" \
         -e "s|<FORUM_URL>|${FORUM_URL}|g" config.php

  su-exec $UID:$GID php flarum cache:clear

  # Composer cache dir and packages list paths
  CACHE_DIR=extensions/.cache
  LIST_FILE=extensions/list

  # Download extra extensions installed with composer wrapup script
  if [ -s "$LIST_FILE" ]; then
    echo "[INFO] Install extra bundled extensions"
    while read extension; do
      echo "[INFO] -------------- Install extension : ${extension} --------------"
      COMPOSER_CACHE_DIR="$CACHE_DIR" su-exec $UID:$GID composer require "$extension"
    done < "$LIST_FILE"
    echo "[INFO] Install extra bundled extensions. DONE."
  else
    echo "[INFO] No installed extensions"
  fi

  echo "[INFO] Init done, launch flarum..."

else

  echo "[INFO] First launch, you must install flarum by opening your browser and setting database parameters."
  rm -rf config.php

fi

# Set permissions
if [ "$DO_CHMOD" = true ]; then
  chown -R $UID:$GID /flarum
fi

# RUN !
exec su-exec $UID:$GID /bin/s6-svscan /services
