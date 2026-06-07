# Developer Documentation

## Architecture overview

Three mandatory services, each in its own container, on a private Docker network
named `inception`. NGINX is the only container exposed to the host (port 443).

```
                 host :443 (https)
                      │
              ┌───────▼───────┐
              │     nginx     │  TLS 1.2/1.3, reverse proxy
              └───┬───────┬───┘
        fastcgi   │       │  proxy /adminer
          :9000   │       │  :8080
            ┌─────▼──┐  ┌─▼───────┐
            │wordpress│  │ adminer │ (bonus)
            │ php-fpm │  └─────────┘
            └────┬────┘
           :3306 │
            ┌────▼────┐
            │ mariadb │
            └─────────┘

volumes (named, stored on host under /home/chpasqui/data):
  - wordpress  -> /var/www/html      (WP files, shared nginx <-> wordpress)
  - mariadb    -> /var/lib/mysql     (database)
```

## Prerequisites

- A Linux virtual machine
- Docker and Docker Compose plugin installed (`docker compose version`)
- `make` available
- `sudo` rights (the volume folders live under `/home/chpasqui/data`)

## 1. Setup from scratch

### a. Clone

```bash
git clone <repo-url> inception && cd inception
```

### b. Create the secrets (NOT in git)

The containers read passwords from `/run/secrets/*`, mounted from these files.
Four are mandatory, the fifth is just a human-readable reminder:

```bash
mkdir -p secrets
echo "your_db_password"        > secrets/db_password.txt        # MariaDB app user
echo "your_root_password"      > secrets/db_root_password.txt   # MariaDB root
echo "your_wp_admin_password"  > secrets/wp_admin_password.txt  # WP administrator
echo "your_wp_user_password"   > secrets/wp_user_password.txt   # WP second user
echo "logins reminder"         > secrets/credentials.txt        # optional note
```

### c. Create `srcs/.env` (NOT in git)

Only non-sensitive variables here (no passwords — those are in secrets):

```env
DOMAIN_NAME=chpasqui.42.fr

MARIA_DB=wordpress
DB_USER=youruser

WP_ADMIN=chpasqui
WP_ADMIN_EMAIL=chpasqui@student.42.fr

WP_USER=newbie
WP_USER_EMAIL=newbie@example.com
```

> The admin username (`WP_ADMIN`) must NOT contain `admin`/`administrator`.

### d. Point the domain to localhost

Add to `/etc/hosts` on the VM:

```
127.0.0.1   chpasqui.42.fr
```

## 2. Build and launch (Makefile + Docker Compose)

The Makefile wraps Docker Compose. Targets:

| Command       | What it does                                                         |
|---------------|---------------------------------------------------------------------|
| `make`        | creates `/home/chpasqui/data/{mariadb,wordpress}` then `up --build -d` |
| `make down`   | `docker compose down` (stops & removes containers + network)        |
| `make clean`  | `down -v` (also removes volumes) + wipes the data folders           |
| `make fclean` | `clean` + `docker system prune -af` (removes all images/cache)      |
| `make re`     | `fclean` then `make` (full rebuild from scratch)                    |

Under the hood `make` runs:

```bash
docker compose -f srcs/docker-compose.yml up --build -d
```

First boot is slower: the entrypoint scripts initialize the database and install
WordPress. They are guarded (`if [ ! -d ... ]` / `if [ ! -f wp-config.php ]`), so on
later boots they skip init and just start the daemon — this is what makes data persist.

## 3. Managing containers

```bash
docker compose -f srcs/docker-compose.yml ps   # status of the project's containers
docker ps                                       # all running containers
docker ps -a                                    # include stopped ones
docker logs nginx                               # logs of one container
docker logs -f wordpress                        # follow logs live
docker exec -it wordpress bash                  # shell inside a container
docker restart mariadb                          # restart one container
```

## 4. Managing volumes

```bash
docker volume ls                  # list volumes (expect: mariadb, wordpress)
docker volume inspect wordpress   # shows Mountpoint + the /home/chpasqui/data path
docker volume rm wordpress        # remove a volume (data loss!)
```

## 5. Inspecting the database

Log in as root (password = content of `secrets/db_root_password.txt`, typed
interactively so it never appears on screen or in a file dump):

```bash
docker exec -it mariadb mariadb -u root -p
```

Then, inside the MariaDB prompt:

```sql
SHOW DATABASES;                                   -- wordpress must be there
USE wordpress;
SHOW TABLES;                                       -- wp_* tables = not empty
SELECT ID, user_login, user_email FROM wp_users;   -- the WordPress users
SELECT User, Host FROM mysql.user;                 -- the DB-level users
EXIT;
```

`wp_users` lists the WordPress accounts (the administrator + the second user).
`mysql.user` lists the database accounts (`root` + the app user from `DB_USER`).

## 6. Where data is stored and how it persists

| Data         | Host location                   | Volume name |
|--------------|---------------------------------|-------------|
| MariaDB DB   | `/home/chpasqui/data/mariadb`   | `mariadb`   |
| WordPress    | `/home/chpasqui/data/wordpress` | `wordpress` |

The two named volumes are bound to `/home/chpasqui/data` on the host. Because the
data lives on the host disk (not inside the container layer):

- stopping/removing the containers (`make down`) keeps the data,
- rebooting the VM and running `make` again restores the running site with all
  previous changes,
- `restart: always` in the compose file brings the containers back after a crash
  or reboot,
- only `make clean` / `make fclean` (which run `down -v` + wipe the folders)
  actually deletes the data.
