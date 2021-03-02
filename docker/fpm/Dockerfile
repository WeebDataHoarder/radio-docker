FROM php:7.4-fpm-buster

ARG STEWDIO_API_PORT=8011
ARG SITE_HOSTNAME=radio
ARG DEFAULT_API_KEY=null
ARG LASTFM_API_KEY=null
ARG DB_USER=radio
ARG DB_PASSWORD=radio
ARG DB_NAME=music
ARG DB_NAME_TORRENTS=torrents


RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    ffmpeg libpq-dev locales && \
    docker-php-ext-install -j$(nproc) pgsql && \
    sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && locale-gen && update-locale LANG="en_US.UTF-8"


WORKDIR /web/bin
COPY ./services/radio-web/bin .
COPY ./.git/modules/services/radio-web/HEAD /web/.version
COPY ./docker/fpm/config.php .

RUN sed -i "s%api:8011%api:${STEWDIO_API_PORT}%g" /web/bin/config.php && \
    sed -i "s%EXAMPLE_HOSTNAME%${SITE_HOSTNAME}%g" /web/bin/config.php && \
    sed -i "s%EXAMPLE_DEFAULT_API_KEY%${DEFAULT_API_KEY}%g" /web/bin/config.php && \
    sed -i "s%EXAMPLE_LASTFM_API_KEY%api:${LASTFM_API_KEY}%g" /web/bin/config.php && \
    sed -i "s%EXAMPLE_PSQL_STRING_MUSIC%host=db dbname=${DB_NAME} user=${DB_USER} password=${DB_PASSWORD}%g" /web/bin/config.php && \
    sed -i "s%EXAMPLE_PSQL_STRING_TORRENTS%host=db dbname=${DB_NAME_TORRENTS} user=${DB_USER} password=${DB_PASSWORD}%g" /web/bin/config.php