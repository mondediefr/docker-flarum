# mondedie/flarum

![logo](https://i.imgur.com/Bjrtbsc.png "logo")

### What is this ?

Flarum is the next-generation forum software that makes online discussion fun. It's simple, fast, and free. http://flarum.org/

### Features

- Lightweight & secure image
- Based on Alpine Linux 3.4 with **nginx** and **PHP 7**
- Latest Flarum Beta (v0.1.0-beta.5)
- MySQL/Mariadb driver
- OPCache extension configured

### Build-time variables

- **VERSION** = Version of flarum (default: *v0.1.0-beta.5*)

### Environment variables

| Variable | Description | Type | Default value |
| -------- | ----------- | ---- | ------------- |
| **GID** | Flarum user id | *optional* | 991
| **UID** | Flarum group id | *optional* | 991
| **FORUM_URL** | Forum URL | **required** | none
| **DB_HOST** | MariaDB instance ip/hostname | *optional* | mariadb
| **DB_USER** | MariaDB database username | *optional* | flarum
| **DB_NAME** | MariaDB database name | *optional* | flarum
| **DB_PASS** | MariaDB database password | **required** | none
| **MAIL_FROM** | Mail 'from address' | *optional* | none
| **MAIL_HOST** | Mail server FQDN | *optional* | none
| **MAIL_PORT** | Mail server smtp port | *optional* | none
| **MAIL_ENCR** | Encryption protocol, tls (587) or ssl (465) | *optional* | none
| **MAIL_USER** | Username | *optional* | none
| **MAIL_PASS** | Password | *optional* | none

### Volume

* /flarum/www : Flarum directory

## Installation

#### 1 - Pull flarum image

```
docker pull mondedie/flarum
```

#### 2 - Create environment file

```
mkdir -p ~/.config/flarum
touch ~/.config/flarum/.env
chmod 600 ~/.config/flarum/.env
```

Create an `.env` file with your environment variables :

```bash
# vim ~/.config/flarum/.env

UID=991                              # Optional
GID=991                              # Optional

FORUM_URL=https://forum.domain.tld/  # Required

DB_HOST=mariadb                      # Optional
DB_NAME=flarum                       # Optional
DB_USER=flarum                       # Optional
DB_PASS=yyyyyyyy                     # Required

MAIL_FROM=noreply@domain.tld         # Optional
MAIL_HOST=mail.domain.tld            # Optional
MAIL_PORT=465                        # Optional
MAIL_ENCR=ssl                        # Optional
MAIL_USER=admin@domain.tld           # Optional
MAIL_PASS=xxxxxxxx                   # Optional
```

#### 3 - Docker-compose.yml

Adapt to your needs :

```
flarum:
  image: mondedie/flarum
  container_name: flarum
  env_file: ~/.config/flarum/.env
  links:
    - mariadb:mariadb
  volumes:
    - /mnt/docker/flarum:/flarum/www

mariadb:
  image: mariadb:10.1
  container_name: mariadb
  volumes:
    - /mnt/docker/mysql/db:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=xxxxxxxx
    - MYSQL_DATABASE=flarum
    - MYSQL_USER=flarum
    - MYSQL_PASSWORD=yyyyyyyy
```

#### 4 - Reverse proxy setup

See : https://github.com/mondediefr/flarum/wiki/Reverse-proxy-example

#### 5 - Done, congratulation ! :tada:

You can now run Flarum :

```
docker-compose up -d
```

### Default account

* **Username** : *admin*
* **Password** : *password*

### Configuration file

The main configuration file is located here : **/mnt/docker/flarum/app/config.php**

### Screenshot

![flarum](https://i.imgur.com/teqg3od.pngP)
