# Suivi d'évaluation — Inception

Organisé comme la fiche d'éval. Pour chaque partie : ce que le correcteur vérifie,
et ce que je dois savoir montrer / dire. Domaine : `https://chpasqui.42.fr`.

---

## ⭐ Avant tout — préparer le projet (les secrets)

Quand le correcteur **clone mon dépôt dans un dossier vide**, les fichiers secrets
et le `.env` **n'y sont PAS** (ils sont gitignorés, c'est voulu). Donc, **juste après
le clone et AVANT le premier `make`**, je dois les recréer à la main :

1. Créer le dossier `secrets/` avec les 4 mots de passe (+ le rappel) :
   - `secrets/db_password.txt`
   - `secrets/db_root_password.txt`
   - `secrets/wp_admin_password.txt`
   - `secrets/wp_user_password.txt`
   - `secrets/credentials.txt` (aide-mémoire)
2. Créer `srcs/.env` (domaine, noms d'utilisateurs, emails — **aucun mot de passe**).
3. Ajouter `127.0.0.1 chpasqui.42.fr` dans `/etc/hosts`.

> Les commandes exactes pour créer ces fichiers sont dans **DEV_DOC.md**.
> C'est NORMAL de devoir les recréer : le principe d'Inception est que les mots de
> passe ne sont jamais dans git.

Ensuite seulement :

```bash
make
```

---

## Preliminaries

- Aucun mot de passe / credential dans le dépôt git (sinon note = 0).
- ⚠️ Il en reste dans mon **historique** de commits → à nettoyer avant l'éval.

**À dire :** mots de passe en Docker secrets + `.env`, tous gitignorés.

## General instructions

Le correcteur lit mes fichiers et vérifie :
- `srcs/` à la racine + `Makefile` à la racine ✅
- dans `docker-compose.yml` : il y a `networks`, et **pas** `network: host` ni `links` ✅
- nulle part de `--link` ✅
- aucun entrypoint qui tourne en tâche de fond (`tail -f`, `sleep infinity`…) ✅
- images basées sur `debian:bookworm` (avant-dernière stable) ✅
- `make` se lance sans crash ✅

## Activity overview (explication orale)

Savoir expliquer simplement :
- **Docker / docker compose** : Docker isole une appli dans un conteneur léger ;
  compose lance plusieurs conteneurs d'un coup avec un seul fichier.
- **Docker vs VM** : la VM émule un OS entier (lourd, lent) ; le conteneur partage
  le noyau de l'hôte (léger, rapide).
- **La structure** : tout dans `srcs/`, un dossier par service, secrets à part.

## README check

- `README.md` présent. 1re ligne en italique :
  `*This project has been created as part of the 42 curriculum by chpasqui.*`
- Contient : Description, Instructions, Resources (+ usage de l'IA). ✅

## Documentation check

- `USER_DOC.md` (usage utilisateur) et `DEV_DOC.md` (setup, lancement, persistance)
  présents et non vides. ✅

## Simple setup

- Ouvrir `https://chpasqui.42.fr` → le **site WordPress configuré** s'affiche
  (PAS la page d'installation).
- `http://chpasqui.42.fr` (port 80) → **ne marche pas** (normal).
- Avertissement de certificat auto-signé → normal.

## Docker Basics

- Un Dockerfile par service, écrits par moi, images construites en local.
- `docker images` : une image par service.

**À dire :** je n'utilise aucune image toute faite (pas de DockerHub), tout part de
`FROM debian:bookworm`.

## Docker Network

- `docker network ls` : mon réseau apparaît.

**À dire :** un réseau dédié relie mes conteneurs ; ils se parlent par leur nom
(ex : wordpress contacte `mariadb`).

## NGINX with SSL/TLS

- Pas de nginx ailleurs, port 443 uniquement.
- Certificat TLS 1.2 / 1.3 (config dans `inception.conf`).
- `https://chpasqui.42.fr` affiche le site ; `http://` est refusé.

## WordPress with php-fpm and its volume

- Pas de nginx dans le Dockerfile wordpress.
- Volume présent : `docker volume inspect wordpress` → chemin `/home/chpasqui/data`.
- Dans le navigateur :
  - ajouter un **commentaire** avec l'utilisateur,
  - se connecter en **admin** (`chpasqui`, sans "admin") sur `/wp-admin`,
  - **modifier une page** et voir le changement sur le site.

## MariaDB and its volume

- Pas de nginx dans le Dockerfile mariadb.
- Volume présent : `docker volume inspect mariadb` → `/home/chpasqui/data`.
- Savoir se connecter à la base et montrer qu'elle n'est pas vide :

```bash
docker exec -it mariadb mariadb -u root -p
```
(le mot de passe root est demandé : je le tape, il vient de `secrets/db_root_password.txt`)

```sql
USE wordpress;
SELECT user_login FROM wp_users;   -- mes 2 users WordPress
EXIT;
```

**À dire :** la base `wordpress` existe, mes utilisateurs sont dedans ; je tape le
mot de passe à la main, je n'ai pas besoin d'ouvrir le `.env`.

## Persistence!

- Redémarrer la VM, relancer `make`, et vérifier que tout revient :
  le site, le commentaire et la page modifiée sont **toujours là**.

**À dire :** les données sont dans les volumes (sur le disque de l'hôte, dans
`/home/chpasqui/data`), donc elles survivent au redémarrage.

## Configuration modification (demandée en defense)

Le correcteur me demande de changer un port et de relancer.
Exemple (php-fpm 9000 → 9001) :
1. `www.conf` : `listen = 9001`
2. `inception.conf` : `fastcgi_pass wordpress:9001;`
3. `make re`, puis re-tester le site.

## Bonus — Adminer

- `https://chpasqui.42.fr/adminer` s'ouvre.
- Connexion : serveur `mariadb`, user/base du `.env`, mot de passe = `secrets/db_password.txt`.

**À dire :** Adminer est dans son propre conteneur, joignable **uniquement via
nginx** (proxy sur `/adminer`) — nginx reste le seul point d'entrée.

---

## Ce qu'il me reste à faire

- [ ] Nettoyer l'historique git (mots de passe dans les anciens commits)
- [ ] Tester le projet dans la VM, partie par partie
- [ ] M'entraîner à expliquer : Activity overview, Docker Network, Persistence
