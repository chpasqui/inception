FROM debian:bookworm
RUN apt update -y

COPY ./tools/script.sh /

RUN apt install wget -y && apt-get install php pho-mysql -y

CMD["/script.sh"]