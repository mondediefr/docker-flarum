# mondedie/flarum

![logo](https://i.imgur.com/Bjrtbsc.png "logo")

### What is this ?

Flarum is the next-generation forum software that makes online discussion fun. It's simple, fast, and free.

### Features

- Based on Alpine Linux 3.4 with **nginx** and **PHP 7**
- Latest Flarum Beta (v0.1.0-beta.5)
- MySQL/Mariadb driver

### Build-time variables

- **VERSION** : Version of flarum (default *v0.1.0-beta.5*)

### Environment variables

- **GID** = Flarum user id (*optional*, default: 991)
- **UID** = Flarum group id (*optional*, default: 991)
- **FORUM_URL** = Forum URL (**required**)
- **DB_HOST** = MariaDB instance ip/hostname (*optional*, default: mariadb)
- **DB_USER** = MariaDB database username (*optional*, default: flarum)
- **DB_NAME** = MariaDB database name (*optional*, default: flarum)
- **DB_PASS** = MariaDB database password (**required**)
- **MAIL_FROM** = Mail 'from address' (*optional*, default: null)
- **MAIL_HOST** = Mail server FQDN (*optional*, default: null)
- **MAIL_PORT** = Mail server smtp port (*optional*, default: null)
- **MAIL_ENCR** = Encryption protocol (*optional*, default: null)
- **MAIL_USER** = Username (*optional*, default: null)
- **MAIL_PASS** = Password (*optional*, default: null)

#### Mail settings example :

```
MAIL_FROM = noreply@domain.tld
MAIL_HOST = mail.domain.tld
MAIL_PORT = 25 or 465 or 587
MAIL_ENCR = ssl (465) or tls (587)
MAIL_USER = contact@domain.tld
MAIL_PASS = xxxxxxxx
```

### Volume

* /flarum/www : Flarum directory

### Installation

```
docker pull mondedie/flarum

mkdir -p ~/.config/flarum
touch ~/.config/flarum/.env
chmod 600 ~/.config/flarum/.env
```

Create an `.env` file with your environment variables

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

### Docker-compose

#### Docker-compose.yml

```
flarum:
  image: flarum
  container_name: mondedie/flarum
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

#### Run !

```
docker-compose up -d
```

### Reverse proxy example

https://github.com/mondediefr/flarum/wiki/Reverse-proxy-example

### Default account

* **Username** : *admin*
* **Password** : *password*

### Configuration file

The main configuration file is located here : **/mnt/docker/flarum/app/config.php**

### Screenshot

![flarum](https://i.imgur.com/teqg3od.pngP)
