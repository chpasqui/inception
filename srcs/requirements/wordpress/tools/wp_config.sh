#!/bin/bash
set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

if [ ! -f "/var/www/html/wp-config.php" ]; then
    wp config create --allow-root \
        --dbname=$MARIA_DB \
        --dbuser=$DB_USER \
        --dbpass=$DB_PASSWORD\
        --dbhost=mariadb \
        --path=/var/www/html

    wp core install --allow-root \
        --url=$DOMAIN_NAME \
        --title="Inception" \
        --admin_user=$WP_ADMIN \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --path=/var/www/html

    wp user create $WP_USER $WP_USER_EMAIL \
        --allow-root \
        --role=author \
        --user_pass=$WP_USER_PASSWORD \
        --path=/var/www/html
fi

exec "$@"


                