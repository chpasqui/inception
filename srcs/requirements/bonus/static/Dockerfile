FROM debian:bookworm

RUN apt update -y && apt install -y nginx

COPY ./sites /var/www/html

CMD ["nginx", "-g", "daemon off;"]