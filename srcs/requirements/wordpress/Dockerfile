FROM debian:bookworm

RUN apt update && apt install -y php-fpm \
        php-mysql \
        wget \
        mariadb-client\
        unzip\
        vim

RUN wget https://wordpress.org/latest.zip -P /tmp && \
    unzip /tmp/latest.zip -d /tmp && \
    mkdir -p /var/www/ && \
    mv /tmp/wordpress /var/www/html && \
    rm /tmp/latest.zip

# user de php-fpm donner les droits sur dossier pour requete wordpress
RUN chown -R www-data:www-data /var/www/html 