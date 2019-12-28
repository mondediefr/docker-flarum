# Guide for upgrade your flarum container

### Upgrade to v0.1.0-beta.11.1 from v0.1.0-beta.11

:warning: Backup your database, config.php, composer.lock and assets folder  
:warning: Disable all 3rd party extensions prior to upgrading in panel admin.

1 - Update your docker-compose file, see an example [here](https://github.com/mondediefr/docker-flarum/tree/master#2---docker-composeyml)

```yml
version: "3"

services:
  flarum:
    image: mondedie/docker-flarum:0.1.0-beta.11.1-stable
```

2 - Pull the last docker images

```sh
docker pull mondedie/docker-flarum:0.1.0-beta.11.1-stable
docker-compose stop flarum
docker-compose rm flarum
docker-compose up -d flarum
```

3 - Updating your database and removing old assets:

```sh
docker exec -ti flarum php /flarum/app/flarum migrate
docker exec -ti flarum php /flarum/app/flarum cache:clear
```

After that your upgrade is finish. :tada: :tada:

### Upgrade to v0.1.0-beta.11 from v0.1.0-beta.10

:warning: Backup your database, config.php, composer.lock and assets folder  
:warning: Disable all 3rd party extensions prior to upgrading in panel admin.

1 - Update your docker-compose file, see an example [here](https://github.com/mondediefr/docker-flarum/tree/master#2---docker-composeyml)

```yml
version: "3"

services:
  flarum:
    image: mondedie/docker-flarum:0.1.0-beta.11-stable
```

2 - Pull the last docker images

```sh
docker pull mondedie/docker-flarum:0.1.0-beta.11-stable
docker-compose stop flarum
docker-compose rm flarum
docker-compose up -d flarum
```

3 - Updating your database and removing old assets:

```sh
docker exec -ti flarum php /flarum/app/flarum migrate
docker exec -ti flarum php /flarum/app/flarum cache:clear
```

After that your upgrade is finish. :tada: :tada:

### Upgrade to v0.1.0-beta.10 from v0.1.0-beta.8.1

:warning: Backup your database, config.php, composer.lock and assets folder  
:warning: Disable all 3rd party extensions prior to upgrading in panel admin.

1 - Remove `installed.txt` file in assets folder

```sh
rm /mnt/docker/flarum/assets/installed.txt
```

2 - Update your docker-compose file, see an example [here](https://github.com/mondediefr/docker-flarum/tree/master#2---docker-composeyml)

3 - Pull the last docker images

```sh
docker pull mondedie/docker-flarum:0.1.0-beta.10-stable
docker-compose stop flarum
docker-compose rm flarum
docker-compose up -d
```

4 - Updating your database and removing old assets:

```sh
docker exec -ti flarum php /flarum/app/flarum migrate
docker exec -ti flarum php /flarum/app/flarum cache:clear
```

After that your upgrade is finish. :tada: :tada:

### Upgrade to v0.1.0-beta.8.1 from v0.1.0-beta.7.2

:warning: Backup your database, config.php, composer.lock and assets folder  
:warning: Disable all 3rd party extensions prior to upgrading in panel admin.

1 - Add `installed.txt` file in assets folder  
Make sure to mount your assets folder with the folder /flarum/app/public/assets

```sh
touch /mnt/docker/flarum/assets/installed.txt
chown UID:GID /mnt/docker/flarum/assets/installed.txt
```

2 - Create your own environment file

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

# environment variable not required
#FLARUM_ADMIN_USER=admin
#FLARUM_ADMIN_PASS=xxxxxxxxxx
#FLARUM_ADMIN_MAIL=admin@domain.tld
#FLARUM_TITLE=Test flarum
```

```sh
chown UID:GID /mnt/docker/flarum/flarum.env
```

3 - Update your docker-compose file, see an example [here](https://github.com/mondediefr/docker-flarum/tree/master#2---docker-composeyml)

4 - Pull the last docker images

```sh
docker pull mondedie/docker-flarum:0.1.0-beta.8.1-stable
docker-compose stop flarum
docker-compose rm flarum
docker-compose up -d
```

5 - Updating your database and removing old assets:

```sh
docker exec -ti flarum php /flarum/app/flarum migrate
docker exec -ti flarum php /flarum/app/flarum cache:clear
```

Since the flarum-english extension has been renamed to flarum-lang-english, you'll need to to re-enable it from the admin panel.  
After that your upgrade is finish. :tada: :tada:

### Upgrade to v0.1.0-beta.7.2 from v0.1.0-beta.6

:warning: Disable 3rd party extensions prior to upgrading.

```sh
docker pull mondedie/docker-flarum:0.1.0-beta.7.2-stable
docker-compose up -d
```

Navigate to `yourforum.com/admin`, enter your database password and update.

![flarum-update](https://images.mondedie.fr/udl8j4Ue/PueJSigV.png)

Remove and restart your container:

```sh
docker-compose stop flarum
docker-compose rm flarum
docker-compose up -d
```
