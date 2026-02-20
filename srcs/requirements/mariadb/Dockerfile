FROM debian:bullseye
RUN apt update && apt install -y mariadb-server
RUN mkdir -p /run/mysqld
RUN chown mysql:mysql /run/mysqld
COPY conf/50-server.conf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/setup.sh /usr/local/bin
RUN chmod +x /usr/local/bin/setup.sh
ENTRYPOINT ["/usr/local/bin/setup.sh"]
CMD ["mariadbd"]

