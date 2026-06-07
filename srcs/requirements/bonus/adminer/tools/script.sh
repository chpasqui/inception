#!/bin/bash
set -e

mkdir -p /var/www/html
wget -q "https://www.adminer.org/latest.php" -O /var/www/html/adminer.php

cd /var/www/html
exec php -S 0.0.0.0:8080
