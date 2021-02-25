FROM python:3.9-buster

ARG KAWA_API_PORT=4040
ARG STEWDIO_API_PORT=8011

ENV VIRTUAL_ENV=/usr/src/stewdio-api/venv3


RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    postgresql-client locales libchromaprint-tools ffmpeg && \
    sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && locale-gen && update-locale LANG="en_US.UTF-8"

WORKDIR /usr/src/stewdio-api
COPY ./services/stewdio-api .
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install -r requirements.txt

COPY ./docker/stewdio-api/entrypoint.sh /

EXPOSE ${STEWDIO_API_PORT}

WORKDIR /
ENTRYPOINT ["/entrypoint.sh"]