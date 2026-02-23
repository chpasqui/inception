#!/bin/bash

set -e #si une commande echoue stop mon script apres une erreur
# notation bash : "${STATE?Need to set STATE}" || "${DEST:?Need to set DEST non-empty}"
# the first requires STATE to be set but STATE can be an empty string whereas DEST must be set
# and non empty
: "${MARIA_DB:?Missing}"
: "${MARIA_USER:?Missing}"
: "${MARIA_USER_PASSWORD:?Missing}"
: "${ROOT_PASSWORD:?Missing}"

if [ ! -d "/var/lib/mysql/${MARIA_DB}" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    service mariadb start

    mariadb -uroot -e "CREATE DATABASE IF NOT EXISTS \`${MARIA_DB}\`;"
    mariadb -uroot -e "CREATE USER IF NOT EXISTS '${MARIA_USER}'@'%' IDENTIFIED BY '${MARIA_USER_PASSWORD}';"
    mariadb -uroot -e "GRANT ALL PRIVILEGES ON \`${MARIA_DB}\`.* TO '${MARIA_USER}'@'%';"
    mariadb -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWORD}';"
    mariadb -uroot -p"${ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

    mariadb-admin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown #pour arreter le serveur proprement
fi


exec "$@"

# INFOS :
# mariadb-install-db  ->  construit les fondations
# mariadbd	->    ouvre le bâtiment
# mariadb   ->    client qui entre dedans

