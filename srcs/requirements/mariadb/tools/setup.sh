#!/bin/bash

set -e #si une commande echoue stop mon script apres une erreur
# notation bash : "${STATE?Need to set STATE}" || "${DEST:?Need to set DEST non-empty}"
# the first requires STATE to be set but STATE can be an empty string whereas DEST must be set
# and non empty


DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

: "${MARIA_DB:?Missing}"
: "${DB_USER:?Missing}"
: "${DB_PASSWORD:?Missing}"
: "${DB_ROOT_PASSWORD:?Missing}"

if [ ! -d "/var/lib/mysql/${MARIA_DB}" ]; then
    rm -rf /var/lib/mysql/*    
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    service mariadb start

    until mariadb -uroot --connect-timeout=2 -e "SELECT 1" &>/dev/null; do
        sleep 1
    done

    mariadb -uroot -e "CREATE DATABASE IF NOT EXISTS \`${MARIA_DB}\`;"
    mariadb -uroot -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
    mariadb -uroot -e "GRANT ALL PRIVILEGES ON \`${MARIA_DB}\`.* TO '${DB_USER}'@'%';"
    mariadb -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
    mariadb -uroot -p"${DB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

    mariadb-admin -uroot -p"${DB_ROOT_PASSWORD}" shutdown #pour arreter le serveur proprement
fi


exec "$@"

# INFOS :
# mariadb-install-db  ->  construit les fondations
# mariadbd	->    ouvre le bâtiment
# mariadb   ->    client qui entre dedans

