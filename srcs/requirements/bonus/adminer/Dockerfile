FROM debian:bookworm

RUN apt-get update && apt-get install -y wget php-cli php-mysql

RUN mkdir -p /var/www/html \
    && wget "http://www.adminer.org/latest.php" -O /var/www/html/adminer.php \
    && chown -R www-data:www-data /var/www/html/adminer.php \
    && chmod 755 /var/www/html/adminer.php

EXPOSE 80
CMD ["php", "-S", "0.0.0.0:80", "-t", "/var/www/html"]
