FROM nginx:1.19

ARG KAWA_STREAM_PORT=8001
ARG STEWDIO_API_PORT=8011
ARG SITE_HOSTNAME=radio
ARG DATA_MOUNT_PATH=/mnt

RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    ssl-cert brotli zopfli

WORKDIR /web
COPY ./services/radio-web .
RUN rm -rf /web/bin

COPY ./docker/nginx/ffdhe4096.pem /etc/ssl/ffdhe4096.pem

COPY ./docker/nginx/snippets/* /etc/nginx/snippets/
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/radio.conf /etc/nginx/sites-enabled/default
RUN sed -i "s%kawa:8001%kawa:${KAWA_STREAM_PORT}%g" /etc/nginx/sites-enabled/default && \
    sed -i "s%api:8011%api:${STEWDIO_API_PORT}%g" /etc/nginx/sites-enabled/default && \
    sed -i "s%server_name _%server_name ${SITE_HOSTNAME}%g" /etc/nginx/sites-enabled/default && \
    sed -i "s%/mnt%${DATA_MOUNT_PATH}%g" /etc/nginx/sites-enabled/default && \
    res/compress.sh /web/fonts && \
    res/compress.sh /web/img && \
    res/compress.sh /web/js && \
    res/compress.sh /web/js/player && \
    res/compress.sh /web/js/player/codecs && \
    res/compress.sh /web/js/modules && \
    res/compress.sh /web/js/modules/subtitles

EXPOSE 80
EXPOSE 443

HEALTHCHECK --interval=30s --timeout=15s --retries=5 --start-period=1m \
    CMD service nginx status || exit 1