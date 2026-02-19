FROM debian:bullseye
RUN apt update && apt upgrade 
RUN apt install -y mariadb-server
RUN mkdir -p /run/mysqld
RUN chown mysql:mysql /run/mysqld
CMD ["mariadbd"]

