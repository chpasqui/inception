*This project has been created as part of the 42 curriculum by chpasqui.*

## Description

Inception is a system administration project that involves setting up a small
infrastructure using Docker and Docker Compose inside a virtual machine.
The stack consists of three services running in dedicated containers:

- **NGINX** — the only entrypoint, handles HTTPS (TLSv1.2/1.3) on port 443
- **WordPress + php-fpm** — the web application
- **MariaDB** — the database

A bonus service is also included:

- **Adminer** — a lightweight database management UI, reachable through NGINX at `/adminer`

### Virtual Machines vs Docker
A VM emulates an entire operating system, takes a lot of memory, and boots slowly.
Docker containers share the host kernel, are lightweight, boot instantly, and volumes
can be shared between containers and the host.

### Secrets vs Environment Variables
Environment variables (stored in `.env`) are convenient but visible in the container's
environment. Docker secrets are stored securely and mounted as files — better for
passwords and sensitive credentials.

### Docker Network vs Host Network
A Docker network isolates containers from the outside world and lets them communicate
with each other by service name. Host network removes that isolation — the container
shares the host's network stack directly, which is forbidden in this project.

### Docker Volumes vs Bind Mounts
A bind mount links a specific path on the host to the container — tightly coupled to
the host filesystem. A named volume is managed by Docker, stored under Docker's
data directory, and is more portable and easier to share between containers.

## Instructions

```bash
# Clone the repository and go to the project root
make        # builds images and starts all containers
make down   # stops and removes containers
make clean  # removes containers, volumes, and built images
```

The site is accessible at: `https://chpasqui.42.fr`

> Before launching, create the secrets files and the `.env` (see `DEV_DOC.md`),
> and add `chpasqui.42.fr` to your `/etc/hosts`.

## Resources

- https://github.com/Forstman1/inception-42
- https://medium.com/@imyzf/inception-3979046d90a0
- https://github.com/vbachele/Inception
- https://tuto.grademe.fr/inception/
- https://docs.docker.com/engine/storage/volumes/
- https://medium.com/@ssterdev/inception-42-project-part-ii-19a06962cf3b
- https://github.com/azedineouhadou/inception-42/tree/main

**AI usage:** Claude was used to format and structure the Markdown documentation
files (README.md, USER_DOC.md, DEV_DOC.md) and to debug Dockerfile errors.
