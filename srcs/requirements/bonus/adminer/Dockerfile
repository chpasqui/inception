FROM debian:bookworm

RUN apt-get update && apt-get install -y wget php-cli php-mysql

COPY ./tools/script.sh /script.sh
RUN chmod +x /script.sh

EXPOSE 8080
CMD ["/script.sh"]
