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
    rm /tmp/latest.zip &&\
    # user de php-fpm donner les droits sur dossier pour requete wordpress
    chown -R www-data:www-data /var/www/html 

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY tools/wp_config.sh /usr/local/bin
RUN chmod +x /usr/local/bin/wp_config.sh
ENTRYPOINT["/usr/local/bin/wp_config.sh"]