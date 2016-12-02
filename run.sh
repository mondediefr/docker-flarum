#!/bin/sh

# Env variables
export DB_HOST
export DB_USER
export DB_NAME
export DEBUG

# Default values
DB_HOST=${DB_HOST:-mariadb}
DB_USER=${DB_USER:-flarum}
DB_NAME=${DB_NAME:-flarum}
DEBUG=${DEBUG:-false}

# Required env variables
if [ -z "$DB_PASS" ]; then
  echo "[ERROR] Mariadb database password must be set !"
  exit 1
fi

if [ -z "$FORUM_URL" ]; then
  echo "[ERROR] Forum url must be set !"
  exit 1
fi

# Set permissions
chown -R $UID:$GID /flarum /etc/nginx /etc/php7 /var/log /var/lib/nginx /tmp /etc/s6.d

cd /flarum/app

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
chown -R $UID:$GID /flarum

# RUN !
exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
