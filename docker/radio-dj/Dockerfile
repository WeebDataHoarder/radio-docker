FROM php:7.4-cli-bullseye

ARG STEWDIO_API_PORT=8011
ARG KAWA_API_PORT=4040
ARG KAWA_STREAM_PORT=8001

ARG DEFAULT_API_KEY=null

ARG DB_USER=radio
ARG DB_PASSWORD=radio
ARG DB_NAME=music
ARG DB_NAME_TORRENTS=torrents

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN groupadd -r dj && useradd -r -g dj dj && \
    DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    unzip git locales && \
    sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && locale-gen && update-locale LANG="en_US.UTF-8"

WORKDIR /dj
COPY ./services/radio-dj .
COPY ./services/radio-dj/config.example.php config.php

RUN sed -i "s%EXAMPLE_DEFAULT_API_KEY%${DEFAULT_API_KEY}%g" /dj/config.php && \
    sed -i "s%api:8011%api:${STEWDIO_API_PORT}%g" /dj/config.php && \
    sed -i "s%kawa:4040%kawa:${KAWA_API_PORT}%g" /dj/config.php && \
    sed -i "s%kawa:8001%kawa:${KAWA_STREAM_PORT}%g" /dj/config.php && \
    sed -i "s%EXAMPLE_DB_USER%${DB_USER}%g" /dj/config.php && \
    sed -i "s%EXAMPLE_DB_PASSWORD%${DB_PASSWORD}%g" /dj/config.php && \
    sed -i "s%EXAMPLE_DB_HOST%db%g" /dj/config.php && \
    sed -i "s%EXAMPLE_DB_MUSIC_NAME%${DB_NAME}%g" /dj/config.php && \
    sed -i "s%EXAMPLE_DB_TORRENTS_NAME%${DB_NAME_TORRENTS}%g" /dj/config.php && \
    composer update --no-interaction

USER dj

ENTRYPOINT ["php", "/dj/run.php"]