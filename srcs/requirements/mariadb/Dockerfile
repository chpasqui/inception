FROM debian:bullseye
RUN apt update && apt upgrade 
RUN apt install -y mariadb-server
RUN mkdir -p /run/mysqld
RUN chown mysql:mysql /run/mysqld
COPY conf/50-serveur.conf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/setup.sh /run/mysql/
ENTRYPOINT ['/run/mysql/setup.sh']
CMD ["mariadbd"]

