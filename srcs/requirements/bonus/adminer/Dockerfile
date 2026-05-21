FROM debian:bookworm
RUN apt update -y

COPY ./tools/script.sh /

RUN apt install wget -y && apt-get install php pho-mysql -y

RUN wget "http://www.adminer.org/latest.php" -O /var/www/html/adminer.php 
    && chown -R www-data:www-data /var/www/html/adminer.php 
    && chmod 755 /var/www/html/adminer.php

CMD ["php", "-S", "0.0.0.0:80", "-t", "/var/www/html"]