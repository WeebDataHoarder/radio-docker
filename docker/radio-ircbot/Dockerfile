FROM php:7.4-cli-buster

ARG STEWDIO_API_PORT=8011
ARG KAWA_API_PORT=4040
ARG KAWA_STREAM_PORT=8001

ARG SITE_HOSTNAME=radio
ARG DEFAULT_API_KEY=null

ARG DB_USER=radio
ARG DB_PASSWORD=radio
ARG DB_NAME=music
ARG DB_NAME_TORRENTS=torrents

ARG DATA_MOUNT_PATH=/mnt

ARG IRC_SERVER_HOST=irc
ARG IRC_SERVER_PORT=6697
ARG BOT_USE_SATSUKI=false
ARG BOT_USER=miku
ARG BOT_NICK=miku
ARG BOT_PASSWORD=""
ARG BOT_KEYID=miku
ARG BOT_RADIO_CHANNEL="#radio"
ARG BOT_NP_CHANNEL="#radio-np"
ARG IRC_SERVER_PASS=""

RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    python3 python3-pip \
    unzip git locales \
    sox libsox-fmt-all ffmpeg \
    libpq-dev && \
    sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && locale-gen && update-locale LANG="en_US.UTF-8" && \
    docker-php-ext-install -j$(nproc) pgsql && \
    pip3 install cchardet eac-logchecker xld-logchecker

WORKDIR /bot
COPY ./services/radio-ircbot .
COPY ./.git/modules/services/radio-ircbot/HEAD /bot/.version
COPY ./services/radio-ircbot/config.example.php config.php

RUN sed -i "s%EXAMPLE_HOSTNAME%${SITE_HOSTNAME}%g" /bot/config.php && \
    sed -i "s%/mnt%${DATA_MOUNT_PATH}%g" /bot/config.php && \
    sed -i "s%EXAMPLE_DEFAULT_API_KEY%${DEFAULT_API_KEY}%g" /bot/config.php && \
    sed -i "s%EXAMPLE_IRC_SERVER_HOST%${IRC_SERVER_HOST}%g" /bot/config.php && \
    sed -i "s%IRC_SERVER_PORT = 6697%IRC_SERVER_PORT = ${IRC_SERVER_PORT}%g" /bot/config.php && \
    sed -i "s%EXAMPLE_IRC_SERVER_PASS%${IRC_SERVER_PASS}%g" /bot/config.php && \
    sed -i "s%BOT_USE_SATSUKI = false%BOT_USE_SATSUKI = ${BOT_USE_SATSUKI}%g" /bot/config.php && \
    sed -i "s%EXAMPLE_BOT_USER%${BOT_USER}%g" /bot/config.php && \
    sed -i "s%EXAMPLE_BOT_NICK%${BOT_NICK}%g" /bot/config.php && \
    sed -i "s%EXAMPLE_BOT_PASSWORD%${BOT_PASSWORD}%g" /bot/config.php && \
    sed -i "s%EXAMPLE_BOT_KEYID%${BOT_KEYID}%g" /bot/config.php && \
    sed -i "s%EXAMPLE_RADIO_CHANNEL%${BOT_RADIO_CHANNEL}%g" /bot/config.php && \
    sed -i "s%EXAMPLE_NP_CHANNEL%${BOT_NP_CHANNEL}%g" /bot/config.php && \
    sed -i "s%api:8011%api:${STEWDIO_API_PORT}%g" /bot/config.php && \
    sed -i "s%kawa:4040%kawa:${KAWA_API_PORT}%g" /bot/config.php && \
    sed -i "s%kawa:8001%kawa:${KAWA_STREAM_PORT}%g" /bot/config.php && \
    sed -i "s%EXAMPLE_PSQL_STRING_MUSIC%host=db dbname=${DB_NAME} user=${DB_USER} password=${DB_PASSWORD}%g" /bot/config.php && \
    sed -i "s%EXAMPLE_PSQL_STRING_TORRENTS%host=db dbname=${DB_NAME_TORRENTS} user=${DB_USER} password=${DB_PASSWORD}%g" /bot/config.php


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && composer update

ENTRYPOINT ["php", "/bot/bot.php"]