FROM debian:bookworm

RUN apt-get update && apt-get install -y wget php-cli php-mysql

COPY ./tools/script.sh /script.sh
RUN chmod +x /script.sh

<<<<<<< HEAD
RUN wget "http://www.adminer.org/latest.php" -O /var/www/html/adminer.php 
    && chown -R www-data:www-data /var/www/html/adminer.php 
    && chmod 755 /var/www/html/adminer.php

CMD ["php", "-S", "0.0.0.0:80", "-t", "/var/www/html"]
=======
EXPOSE 8080
CMD ["/script.sh"]
>>>>>>> 621a90e07460fab9af5116d5430fdf6871da591b
