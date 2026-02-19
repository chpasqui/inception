FROM debian:bullseye
RUN apt update && apt upgrade 
RUN apt install -y nginx openssl
RUN mkdir -p /etc/nginx/ssl
RUN rm -f /etc/nginx/sites-enabled/default
COPY conf/inception.conf /etc/nginx/sites-enabled/inception.conf
COPY tools/generate_ssl.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/*.sh
EXPOSE 443
ENTRYPOINT ["/usr/local/bin/generate_ssl.sh"]
CMD ["nginx", "-g", "daemon off;"]