# Guide de test & defense — Inception

But : pouvoir tester seule, dans le terminal, chaque point de la fiche d'éval,
et savoir **l'expliquer**. Pour chaque section : la/les commande(s), le résultat
attendu, et ce que tu dois savoir dire.

> Remplace `chpasqui` par ton login partout. Domaine : `https://chpasqui.42.fr`.

---

## 0. Lancer / relancer proprement

```bash
# Repartir d'une VM propre (ce que le correcteur tape avant de commencer) :
docker stop $(docker ps -qa); docker rm $(docker ps -qa); \
docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); \
docker network rm $(docker network ls -q) 2>/dev/null

# Puis lancer le projet :
make

# Suivre la construction / le démarrage :
docker compose -f srcs/docker-compose.yml ps
docker logs -f wordpress      # Ctrl-C pour sortir
```

Pré-requis avant `make` : fichiers `secrets/*`, `srcs/.env`, et la ligne
`127.0.0.1 chpasqui.42.fr` dans `/etc/hosts`. (Détails dans DEV_DOC.md.)

---

## 1. Préliminaire — aucun secret dans git (= 0 si raté)

```bash
git ls-files | grep -Ei 'secret|\.env'      # doit ne RIEN afficher
git log --oneline -- secrets srcs/.env      # doit être vide (historique propre)
```

**À dire :** les mots de passe sont en local (Docker secrets) + dans `.env`, tous
gitignorés ; rien de confidentiel dans le dépôt ni dans l'historique.

---

## 2. General instructions (lecture des fichiers)

```bash
grep -n 'network' srcs/docker-compose.yml          # 'networks:' présent, PAS 'network: host'
grep -rn 'links\|--link' srcs/ Makefile            # doit ne RIEN afficher
grep -rn 'tail -f\|sleep infinity\|while true' srcs/  # doit ne RIEN afficher
grep -rn '^FROM' srcs/requirements                 # doit être debian:bookworm (avant-dernière stable)
```

**À dire :** réseau bridge dédié `inception` (pas `host`, pas de `links`/`--link`).
Aucun hack PID1 : chaque entrypoint finit par `exec`, le daemon devient PID 1.
Base `debian:bookworm` = avant-dernière version stable de Debian.

---

## 3. Activity overview (explication orale — pas de commande)

Savoir expliquer simplement :
- **Docker** : isole une app + ses dépendances dans un conteneur léger qui partage
  le noyau de l'hôte. **docker compose** : orchestre plusieurs conteneurs depuis
  un seul fichier YAML, une seule commande.
- **Image avec / sans compose** : c'est la même image ; compose ajoute juste
  l'orchestration (réseau, volumes, dépendances, variables) au lieu de longs
  `docker run` à la main.
- **Docker vs VM** : la VM émule un OS complet (lourd, lent à booter) ; le conteneur
  partage le noyau de l'hôte (léger, démarre instantanément).
- **Structure** : `srcs/` contient tout (compose + un dossier par service avec son
  Dockerfile/conf/tools), Makefile à la racine, secrets isolés.

---

## 4. README / USER_DOC / DEV_DOC présents

```bash
ls README.md USER_DOC.md DEV_DOC.md
head -1 README.md          # 1re ligne au format "*This project... by chpasqui.*" (italique)
```

README doit contenir : Description, Instructions, Resources (+ usage de l'IA).
USER_DOC : usage côté utilisateur. DEV_DOC : prérequis, setup, lancement, persistance.

---

## 5. NGINX accessible en 443 + SSL/TLS

```bash
# http (port 80) doit ÉCHOUER :
curl -I http://chpasqui.42.fr          # -> connexion refusée / impossible

# https doit MARCHER (-k car certificat auto-signé) :
curl -kI https://chpasqui.42.fr        # -> HTTP/1.1 200 OK

# Vérifier les versions TLS acceptées :
openssl s_client -connect chpasqui.42.fr:443 -tls1_2 </dev/null 2>/dev/null | grep Protocol
openssl s_client -connect chpasqui.42.fr:443 -tls1_3 </dev/null 2>/dev/null | grep Protocol
openssl s_client -connect chpasqui.42.fr:443 -tls1_1 </dev/null 2>&1 | grep -i 'alert\|fail'  # doit être refusé
```

Puis ouvrir `https://chpasqui.42.fr` dans le navigateur : on doit voir le **site
WordPress configuré** (PAS la page d'installation). Avertissement de certificat
auto-signé = normal.

**À dire :** nginx est l'unique point d'entrée, port 443 uniquement, TLS 1.2/1.3
seulement (config dans `inception.conf`), certificat auto-signé généré au démarrage.

---

## 6. Docker basics (images & build)

```bash
docker images                          # une image par service, nommée comme le service
docker compose -f srcs/docker-compose.yml ps   # tous les conteneurs Up, sans crash
```

**À dire :** un Dockerfile écrit à la main par service, images construites
localement (pas de pull d'image toute faite type DockerHub), toutes en
`FROM debian:bookworm`.

---

## 7. Docker network

```bash
docker network ls                      # le réseau du projet doit apparaître
docker network inspect srcs_inception  # (ou 'inception') -> voir les 3 conteneurs connectés
```

**À dire :** un réseau bridge dédié connecte les conteneurs ; ils se joignent par
leur **nom de service** (ex : wordpress joint `mariadb`), isolés de l'extérieur.

---

## 8. WordPress + php-fpm + volume

```bash
# Pas de nginx dans l'image wordpress :
grep -i nginx srcs/requirements/wordpress/Dockerfile     # doit ne RIEN afficher

docker compose -f srcs/docker-compose.yml ps wordpress   # conteneur créé / Up

# Volume :
docker volume ls
docker volume inspect wordpress | grep -i mountpoint     # doit contenir /home/chpasqui/data
```

Dans le navigateur :
- ajouter un **commentaire** avec l'utilisateur WordPress,
- se connecter en **admin** sur `/wp-admin` (login `chpasqui`, sans "admin"),
- **éditer une page** depuis le dashboard et vérifier le changement sur le site.

---

## 9. MariaDB + volume + montrer les users (SANS le .env)

```bash
grep -i nginx srcs/requirements/mariadb/Dockerfile       # rien
docker volume inspect mariadb | grep -i mountpoint       # /home/chpasqui/data

# Se connecter à la base (mot de passe root tapé à la main = secrets/db_root_password.txt) :
docker exec -it mariadb mariadb -u root -p
```

Dans l'invite MariaDB :

```sql
SHOW DATABASES;                                   -- 'wordpress' présent
USE wordpress;
SHOW TABLES;                                       -- des tables wp_* => base non vide
SELECT ID, user_login, user_email FROM wp_users;   -- mes 2 users WordPress
SELECT User, Host FROM mysql.user;                 -- mes users base (root + l'user .env)
EXIT;
```

**À dire :** `wp_users` = les comptes WordPress (admin `chpasqui` + `newbie`).
`mysql.user` = les comptes de la base. Le mot de passe est tapé à la main (jamais
affiché), il vient du fichier secret — je n'ai pas besoin d'ouvrir le `.env`
(qui ne contient de toute façon aucun mot de passe, juste des noms).

---

## 10. Persistance (test clé)

```bash
sudo reboot
# ... après redémarrage de la VM :
cd inception && make
docker compose -f srcs/docker-compose.yml ps      # tout remonte
```

Vérifier dans le navigateur : le site, le commentaire et la page modifiée sont
toujours là.

**À dire :** les données vivent dans les volumes nommés bindés sur
`/home/chpasqui/data` (sur le disque de l'hôte), donc elles survivent au reboot ;
les scripts d'init sont gardés par un `if` et ne ré-initialisent pas.

---

## 11. Modification de config (demandée en defense)

Le correcteur demande de changer un port et de relancer. Exemple : passer php-fpm
de 9000 à 9001.

1. `srcs/requirements/wordpress/conf/www.conf` : `listen = 9001`
2. `srcs/requirements/nginx/conf/inception.conf` : `fastcgi_pass wordpress:9001;`
3. (option) `expose: "9001"` dans le service wordpress du compose
4. Relancer :

```bash
make re        # rebuild complet
```

Vérifier que le site remarche en https. **À dire :** je modifie la conf du service
+ la référence côté nginx, puis je reconstruis.

---

## 12. Bonus — Adminer

```bash
docker compose -f srcs/docker-compose.yml ps adminer   # Up
curl -kI https://chpasqui.42.fr/adminer                # 200
```

Ouvrir `https://chpasqui.42.fr/adminer` : se connecter avec
serveur `mariadb`, user/base du `.env`, mot de passe = `secrets/db_password.txt`.

**À dire :** Adminer tourne dans son propre conteneur (serveur PHP intégré, port
8080 interne), joignable **uniquement via nginx** (proxy sur `/adminer`) — nginx
reste le seul point d'entrée.

---

## Récap — ce qu'il me reste à faire

- [ ] Nettoyer l'historique git (mots de passe encore dans les anciens commits)
- [ ] Tester chaque section ci-dessus dans la VM
- [ ] M'entraîner à expliquer les sections 3, 7 et 10 à l'oral
