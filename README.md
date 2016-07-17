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

- **GID** = vmail user id (*optional*, default: 991)
- **UID** = vmail user id (*optional*, default: 991)
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

* /flarum : Flarum directory

### Docker-compose

#### Docker-compose.yml

```
flarum:
  image: flarum
  container_name: mondedie/flarum
  links:
    - mariadb:mariadb
  environment:
    - DB_PASS=yyyyyyyy
    - FORUM_URL=https://forum.domain.tld/
    - MAIL_FROM=noreply@domain.tld
    - MAIL_HOST=mail.domain.tld
    - MAIL_PORT=465
    - MAIL_USER=noreply@domain.tld
    - MAIL_PASS=zzzzzzzz
    - MAIL_ENCR=ssl
  volumes:
    - /mnt/docker/flarum:/flarum

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

### Default account

* **Username** : *admin*
* **Password** : *password*

### Configuration file

The main configuration file is located here : **/mnt/docker/flarum/config.php**
