# User Documentation

## What services does the stack provide?

| Service   | Role                                          |
|-----------|-----------------------------------------------|
| NGINX     | Web server, HTTPS entrypoint on port 443      |
| WordPress | Website and admin panel                       |
| MariaDB   | Database storing WordPress content            |
| Adminer   | Database management UI (bonus), via `/adminer`|

## Start and stop the project

```bash
make        # starts everything
make down   # stops everything
make clean  # stops everything and removes volumes + images
```

## Access the website and admin panel

- Website: `https://chpasqui.42.fr`
- Admin panel: `https://chpasqui.42.fr/wp-admin`
- Adminer (database UI): `https://chpasqui.42.fr/adminer`

Make sure `chpasqui.42.fr` points to your VM's local IP in `/etc/hosts`.

## Locate and manage credentials

Passwords are stored as Docker secrets, and non-sensitive variables in `.env`:

- `secrets/db_password.txt` — MariaDB user password
- `secrets/db_root_password.txt` — MariaDB root password
- `secrets/wp_admin_password.txt` — WordPress admin password
- `secrets/wp_user_password.txt` — WordPress second user password
- `secrets/credentials.txt` — reminder of the WordPress logins
- `srcs/.env` — environment variables (domain name, DB name, users, emails)

These files are **not committed to git**.

## Check that services are running correctly

```bash
docker ps                        # lists running containers
docker logs nginx                # logs for a specific container
docker exec -it wordpress bash   # open a shell inside a container
```

All containers (`nginx`, `wordpress`, `mariadb`, `adminer`) should show as `Up`.
