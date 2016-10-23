# mondedie/flarum

![logo](https://i.imgur.com/Bjrtbsc.png "logo")

### What is this ?

Flarum is the next-generation forum software that makes online discussion fun. It's simple, fast, and free. http://flarum.org/

### Features

- Lightweight & secure image
- Based on Alpine Linux with **nginx** and **PHP 7**
- Latest Flarum Beta (v0.1.0-beta.6)
- MySQL/Mariadb driver
- OPCache extension configured

### Build-time variables

- **VERSION** = Version of flarum (default: *v0.1.0-beta.6*)

### Ports

- **8888**

### Volume

- **/flarum/app/assets** : Flarum assets directory

### Environment variables

| Variable | Description | Type | Default value |
| -------- | ----------- | ---- | ------------- |
| **GID** | Flarum user id | *optional* | 991
| **UID** | Flarum group id | *optional* | 991
| **DEBUG** | Flarum debug mode | *optional* | false
| **FORUM_URL** | Forum URL | **required** | none
| **DB_HOST** | MariaDB instance ip/hostname | *optional* | mariadb
| **DB_USER** | MariaDB database username | *optional* | flarum
| **DB_NAME** | MariaDB database name | *optional* | flarum
| **DB_PASS** | MariaDB database password | **required** | none

## Installation

#### 1 - Pull flarum image

```
docker pull mondedie/flarum
```

#### 2 - Docker-compose.yml

Adapt to your needs :

```
flarum:
  image: mondedie/flarum
  container_name: flarum
  links:
    - mariadb:mariadb
  environment:
    - FORUM_URL=https://forum.domain.tld
    - DB_PASS=xxxxxxxx
  volumes:
    - /mnt/docker/flarum:/flarum/app/assets

mariadb:
  image: mariadb:10.1
  container_name: mariadb
  volumes:
    - /mnt/docker/mysql/db:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=xxxxxxxx
    - MYSQL_DATABASE=flarum
    - MYSQL_USER=flarum
    - MYSQL_PASSWORD=xxxxxxxx
```

#### 4 - Reverse proxy setup

See : https://github.com/mondediefr/flarum/wiki/Reverse-proxy-example

#### 5 - Done, congratulation ! :tada:

You can now run Flarum :

```
docker-compose up -d
```

### Install custom extensions

**Flarum extensions list :** https://packagist.org/search/?q=flarum-ext

#### Install an extension

```
docker exec -ti flarum extension require some/extension
```

#### Remove an extension

```
docker exec -ti flarum extension remove some/extension
```

#### List all extensions

```
docker exec -ti flarum extension list
```

### Screenshot

![flarum](https://i.imgur.com/teqg3od.pngP)
