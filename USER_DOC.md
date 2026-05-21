User documentation This file must explain, in clear and simple
terms, how an end user or administrator can:
◦ Understand what services are provided by the stack.
◦ Start and stop the project.
◦ Access the website and the administration panel.
◦ Locate and manage credentials.
◦ Check that the services are running correctly.

DOCKER CLIENT COMMANDS :
docker build: Used to build a Docker image from a Dockerfile.
docker run: Used to run a Docker container based on a Docker image.
docker run -it : access to the terminal of the docker
docker pull: Used to pull a Docker image from a registry, such as Docker Hub.
docker push: Used to push a Docker image to a registry.
docker ps: Used to list the running Docker containers on a system.
docker ps -a : used to list all docker even the ones not running
docker stop: Used to stop a running Docker container.
docker rm: Used to remove a Docker container.
docker rmi: Used to remove a Docker image.
docker exec: Used to execute a command in a running Docker container.
docker logs: Used to view the logs for a Docker container.
docker images : to see all images created

mais ou est ce qu on utilise les commandes de docker compose ?

DOCKER COMPOSE COMMANDS :
up: Create and start containers
down: Stop and remove containers, networks, images, and volumes
start: Start existing containers
stop: Stop running containers
restart: Restart running containers
build: Build images
ps: List containers
logs: View output from containers
exec: Run a command in a running container
pull: Pull images from a registry
push: Push images to a registry

commande dans le terminal :
my_print_default --verbose


# User Documentation

## What services does the stack provide?

| Service   | Role                                      |
|-----------|-------------------------------------------|
| NGINX     | Web server, HTTPS entrypoint on port 443  |
| WordPress | Website and admin panel                   |
| MariaDB   | Database storing WordPress content        |

## Start and stop the project

```bash
make        # starts everything
make down   # stops everything
```

## Access the website and admin panel

- Website: `https://chpasqui.42.fr`
- Admin panel: `https://chpasqui.42.fr/wp-admin`

Make sure `chpasqui.42.fr` points to your VM's local IP in `/etc/hosts`.

## Locate and manage credentials

All credentials are stored in:
- `secrets/credentials.txt` — WordPress admin login
- `secrets/db_password.txt` — MariaDB user password
- `secrets/db_root_password.txt` — MariaDB root password
- `srcs/.env` — environment variables (domain name, DB user, etc.)

These files are **not committed to git**.

## Check that services are running correctly

```bash
docker ps                        # lists running containers
docker logs nginx                # logs for a specific container
docker exec -it wordpress bash   # open a shell inside a container
```

All three containers (`nginx`, `wordpress`, `mariadb`) should show as `Up`.
