# mondedie/flarum

![logo](https://i.imgur.com/Bjrtbsc.png)

[![](https://github.com/mondediefr/docker-flarum/workflows/build/badge.svg)](https://github.com/mondediefr/docker-flarum/actions)
[![](https://img.shields.io/docker/pulls/mondedie/flarum)](https://hub.docker.com/r/mondedie/flarum)
[![](https://img.shields.io/docker/stars/mondedie/flarum)](https://hub.docker.com/r/mondedie/flarum)

### Tag available

 - **latest** [(Dockerfile)](https://github.com/mondediefr/docker-flarum/blob/master/Dockerfile)
 - **stable** [(Dockerfile)](https://github.com/mondediefr/docker-flarum/blob/master/Dockerfile)
 - **1.0.0** [(Dockerfile)](https://github.com/mondediefr/docker-flarum/blob/1.0.0/Dockerfile)
 - **0.1.0-beta.16** [(Dockerfile)](https://github.com/mondediefr/docker-flarum/blob/0.1.0-beta.16/Dockerfile)
 - **0.1.0-beta.15** [(Dockerfile)](https://github.com/mondediefr/docker-flarum/blob/0.1.0-beta.15/Dockerfile)

### Features

- Multi-platform image: `linux/386`, `linux/amd64`, `linux/arm/v6`, `linux/arm/v7`, `linux/arm64`
- Lightweight & secure image
- Based on Alpine Linux 3.13
- **nginx** and **PHP 8.0**
- Latest [Flarum Core](https://github.com/flarum/core) (v1.0.0)
- MySQL/Mariadb driver
- OPCache extension configured

### Build-time variables

- **VERSION** = Version of [flarum/flarum](https://github.com/flarum/flarum) skeleton (default: *v1.0.0*)

### Ports

- Default: **8888** (configurable)

### Volume

- **/flarum/app/extensions** : Flarum extension directory
- **/flarum/app/public/assets** : Flarum assets directory
- **/flarum/app/storage/logs** : Flarum logs directory
- **/etc/nginx/flarum** : Nginx location directory

### Environment variables

| Variable | Description | Type | Default value |
| -------- | ----------- | ---- | ------------- |
| **UID** | Flarum user id | *optional* | 991
| **GID** | Flarum group id | *optional* | 991
| **DEBUG** | Flarum debug mode | *optional* | false
| **FORUM_URL** | Forum URL | **required** | none
| **DB_HOST** | MariaDB instance ip/hostname | *optional* | mariadb
| **DB_USER** | MariaDB database username | *optional* | flarum
| **DB_NAME** | MariaDB database name | *optional* | flarum
| **DB_PASS** | MariaDB database password | **required** | none
| **DB_PREF** | Flarum tables prefix | *optional* | none
| **DB_PORT** | MariaDB database port | *optional* | 3306
| **FLARUM_PORT** | Port to run Flarum on inside the container | *optional* | 8888
| **UPLOAD_MAX_SIZE** | The maximum size of an uploaded file | *optional* | 50M
| **PHP_MEMORY_LIMIT** | PHP memory limit | *optional* | 128M |
| **OPCACHE_MEMORY_LIMIT** | OPcache memory size in megabytes | *optional* | 128
| **LOG_TO_STDOUT** | Enable nginx and php error logs to stdout | *optional* | false
| **GITHUB_TOKEN_AUTH** | Github token to download private extensions | *optional* | false
| **PHP_EXTENSIONS** | Install additional php extensions | *optional* | none

### Required environment variable for first installation

| Variable | Description | Type | Default value |
| -------- | ----------- | ---- | ------------- |
| **FLARUM_ADMIN_USER** | Name of your user admin | **required** | none
| **FLARUM_ADMIN_PASS** | User admin password | **required** | none
| **FLARUM_ADMIN_MAIL** | User admin adress mail | **required** | none
| **FLARUM_TITLE** | Set a name of your flarum | *optional* | Docker-Flarum

## Installation

#### 1 - Pull flarum image

```bash
# Pull from hub.docker.com :
docker pull mondedie/flarum:latest

# or build it manually :
docker build -t mondedie/flarum:latest https://github.com/mondediefr/docker-flarum.git
```

#### 2 - Docker-compose.yml

```yml
version: "3"

services:
  flarum:
    image: mondedie/flarum:stable
    container_name: flarum
    env_file:
      - /mnt/docker/flarum/flarum.env
    volumes:
      - /mnt/docker/flarum/assets:/flarum/app/public/assets
      - /mnt/docker/flarum/extensions:/flarum/app/extensions
      - /mnt/docker/flarum/storage/logs:/flarum/app/storage/logs
      - /mnt/docker/flarum/nginx:/etc/nginx/flarum
    ports:
      - 80:8888
    depends_on:
      - mariadb

  mariadb:
    image: mariadb:10.5
    container_name: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=xxxxxxxxxx
      - MYSQL_DATABASE=flarum
      - MYSQL_USER=flarum
      - MYSQL_PASSWORD=xxxxxxxxxx
    volumes:
      - /mnt/docker/mysql/db:/var/lib/mysql
```

#### 3 - Run it

You need a reverse proxy to access flarum, this is not described here. You can use the solution of your choice (Traefik, Nginx, Apache, Haproxy, Caddy, H2O...etc).

Create a environment file (see docker-compose: /mnt/docker/flarum/flarum.env [here](https://github.com/mondediefr/docker-flarum/tree/master#2---docker-composeyml))

```
# vi /mnt/docker/flarum/flarum.env

DEBUG=false
FORUM_URL=http://domain.tld

# Database configuration
DB_HOST=mariadb
DB_NAME=flarum
DB_USER=flarum
DB_PASS=xxxxxxxxxx
DB_PREF=flarum_
DB_PORT=3306

# User admin flarum (environment variable for first installation)
# /!\ admin password must contain at least 8 characters /!\
FLARUM_ADMIN_USER=admin
FLARUM_ADMIN_PASS=xxxxxxxxxx
FLARUM_ADMIN_MAIL=admin@domain.tld
FLARUM_TITLE=Test flarum
```

Run your docker-compose

```sh
docker-compose up -d mariadb
# Wait a moment for the creation of the database
docker-compose up -d flarum
```

* :warning: Your admin password must contain at least **8 characters** (FLARUM_ADMIN_PASS).
* If you get an error 500 with _Something went wrong_ message, switch the `DEBUG` environment variable to `true` to see the actual error message in your browser.

![flarum-home](http://i.imgur.com/6kH9iTV.png)

### Install additional php extensions

```yml
version: "3"

services:
  flarum:
    image: mondedie/flarum:stable
    container_name: flarum
    environment:
      - PHP_EXTENSIONS=gmp session brotli
    volumes:
      - /mnt/docker/flarum/assets:/flarum/app/public/assets
      - /mnt/docker/flarum/extensions:/flarum/app/extensions
      - /mnt/docker/flarum/storage/logs:/flarum/app/storage/logs
      - /mnt/docker/flarum/nginx:/etc/nginx/flarum
```

This example install php8-gmp php8-session and php8-brotli with apk  
You can find a php extension here https://pkgs.alpinelinux.org/packages?name=php8-*&branch=v3.13&arch=x86_64

### Install custom extensions

**Flarum extensions list :** https://flagrow.io/extensions

#### Install an extension

```sh
docker exec -ti flarum extension require some/extension
```

#### Remove an extension

```sh
docker exec -ti flarum extension remove some/extension
```

#### List all extensions

```sh
docker exec -ti flarum extension list
```

### Custom vhost flarum nginx

File to change the vhost flarum `/etc/nginx/flarum/custom-vhost-flarum.conf`  
To use file custom-vhost-flarum.conf add volume `/etc/nginx/flarum`
Create file in `/mnt/docker/flarum/nginx/custom-vhost-flarum.conf`

```nginx
# Example of custom vhost flarum for nginx
# fix nginx issue for fof/sitemap (https://github.com/FriendsOfFlarum/sitemap)

location = /sitemap.xml {
  try_files $uri $uri/ /index.php?$query_string;
}
```

### Custom composer repositories

To use the composer repository system, add your repo name and json representation in `/mnt/docker/flarum/extensions/composer.repositories.txt`:

```
my_private_repo|{"type":"path","url":"extensions/*/"}
my_public_repo|{"type":"vcs","url":"https://github.com/my/repo"}
```

Example for a private repository in github

Add this in `/mnt/docker/flarum/extensions/composer.repositories.txt`
```
username|{"type":"vcs","url":"https://github.com/username/my-private-repo"}
```

Create a token in github with full control of privates repository  
https://github.com/settings/tokens

Add your github token in var environment
```
GITHUB_TOKEN_AUTH=XXXXXXXXXXXXXXX
```

Add your repo in the list file `/mnt/docker/flarum/extensions/list`
```
username/my-private-repo:0.1.0
```

https://getcomposer.org/doc/03-cli.md#modifying-repositories

### Guide for upgrade your flarum container

See the instructions [here](https://github.com/mondediefr/docker-flarum/blob/master/UPGRADE.md)

## License

Docker image [mondedie/flarum](https://hub.docker.com/r/mondedie/flarum) is released under [MIT License](https://github.com/mondediefr/docker-flarum/blob/master/LICENSE).
