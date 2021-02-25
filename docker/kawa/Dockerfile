FROM rust:1.50-buster

ARG KAWA_API_PORT=4040
ARG KAWA_STREAM_PORT=8001

WORKDIR /usr/src/kawa

RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    libmp3lame-dev libopus-dev libvorbis-dev \
    libavcodec-dev libavutil-dev libavformat-dev libavfilter-dev libavdevice-dev libswresample-dev libswscale-dev

COPY ./services/kawa .
RUN cargo install --path . --locked --root /usr

# Code no longer needed
RUN rm -rf /usr/src/kawa


COPY ./docker/kawa/error.flac /
COPY ./docker/kawa/entrypoint.sh /

EXPOSE ${KAWA_API_PORT}
EXPOSE ${KAWA_STREAM_PORT}

WORKDIR /
ENTRYPOINT ["/entrypoint.sh"]