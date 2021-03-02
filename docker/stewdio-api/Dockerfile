FROM python:3.9-buster

ARG KAWA_API_PORT=4040
ARG STEWDIO_API_PORT=8011

ARG DB_USER=radio
ARG DB_PASSWORD=radio
ARG DB_NAME=music
ARG ACOUSTID_API_KEY=""
ARG DATA_MOUNT_PATH="/mnt"

ENV VIRTUAL_ENV=/usr/src/stewdio-api/venv3


RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    postgresql-client locales libchromaprint-tools ffmpeg jq && \
    sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && locale-gen && update-locale LANG="en_US.UTF-8"

WORKDIR /usr/src/stewdio-api
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY ./docker/stewdio-api/entrypoint.sh /
COPY ./docker/stewdio-api/api.conf /etc/stewdio/api.conf

#Cache requirements in advance independent of rest of code
COPY ./services/stewdio-api/requirements.txt .
COPY ./services/stewdio-api/setup.py .
COPY ./services/stewdio-api/stewdio/search/requirements.txt ./stewdio/search/
RUN pip install -r requirements.txt && \
    rm -rf requirements.txt setup.py ./stewdio

COPY ./services/stewdio-api .

RUN rm stewdio-api.conf && \
    sed -i "s%sqlalchemy.url = postgres://localhost/music%sqlalchemy.url = postgres://${DB_USER}:${DB_PASSWORD}@db/${DB_NAME}%g" /usr/src/stewdio-api/alembic.ini && \
    sed -i "s%kawa:4040%kawa:${KAWA_API_PORT}%g" /etc/stewdio/api.conf && \
    sed -i "s%ACOUSTID_API_KEY%${ACOUSTID_API_KEY}%g" /etc/stewdio/api.conf && \
    sed -i "s%DB_USER%${DB_USER}%g" /etc/stewdio/api.conf && \
    sed -i "s%DB_PASSWORD%${DB_PASSWORD}%g" /etc/stewdio/api.conf && \
    sed -i "s%DB_NAME%${DB_NAME}%g" /etc/stewdio/api.conf && \
    sed -i "s%main = /mnt%main = ${DATA_MOUNT_PATH}%g" /etc/stewdio/api.conf

EXPOSE ${STEWDIO_API_PORT}


HEALTHCHECK --interval=30s --timeout=15s --retries=5 --start-period=1m \
    CMD curl --fail http://127.0.0.1:${STEWDIO_API_PORT}/api/status | jq --exit-status -r '.storage.main' || exit 1

ENTRYPOINT ["/entrypoint.sh"]