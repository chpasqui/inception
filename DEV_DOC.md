# Developer Documentation

## Prerequisites

- A Linux virtual machine
- Docker and Docker Compose installed
- `make` available

## Setting up from scratch

1. Clone the repository
2. Create the secrets files (not included in git):

```bash
mkdir secrets
echo "your_db_password"      > secrets/db_password.txt
echo "your_root_password"    > secrets/db_root_password.txt
echo "your_wp_credentials"   > secrets/credentials.txt
```

3. Fill in `srcs/.env`:

```env
DOMAIN_NAME=chpasqui.42.fr
MYSQL_USER=youruser
MYSQL_DATABASE=wordpress
```

4. Add your domain to `/etc/hosts` on the host machine:

```
127.0.0.1   chpasqui.42.fr
```

## Build and launch

```bash
make        # runs: docker compose -f srcs/docker-compose.yml up --build -d
make down   # runs: docker compose -f srcs/docker-compose.yml down
make clean  # down + remove volumes and images
```

## Useful Docker commands

```bash
docker ps                        # running containers
docker ps -a                     # all containers including stopped
docker logs <service>            # logs of a container
docker exec -it <service> bash   # shell inside a container
docker images                    # list built images
docker volume ls                 # list volumes
docker inspect <volume>          # details about a volume
```

## Where data is stored

| Data         | Location on host                | Volume name  |
|--------------|---------------------------------|--------------|
| WordPress DB | `/home/chpasqui/data/mariadb`   | `mariadb`    |
| WP files     | `/home/chpasqui/data/wordpress` | `wordpress`  |

Data persists across container restarts because it is stored in named Docker volumes
mapped to the host filesystem. Removing containers does **not** delete this data —
you must explicitly remove the volumes with `docker volume rm` or `make clean`.