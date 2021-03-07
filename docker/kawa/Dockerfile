FROM rust:1.50-buster

ARG KAWA_LOG_ARG=info
ENV RUST_LOG=${KAWA_LOG_ARG}
ENV RUST_BACKTRACE=full

ARG KAWA_API_PORT=4040
ARG KAWA_STREAM_PORT=8001

ARG KAWA_STREAM_NAME=radio
ARG KAWA_RANDOM_SONG_URL=""
ARG KAWA_NEXT_RANDOM_URL=""
ARG KAWA_NOW_PLAYING_URL=""

WORKDIR /usr/src/kawa

RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    libmp3lame-dev libopus-dev libvorbis-dev \
    libavcodec-dev libavutil-dev libavformat-dev libavfilter-dev libavdevice-dev libswresample-dev libswscale-dev \
    jq

# Do this to cache dependency building
COPY ./docker/kawa/dummy.rs ./dummy.rs
COPY ./docker/kawa/dummy.rs ./kaeru/dummy.rs
COPY ./services/kawa/Cargo.* ./
COPY ./services/kawa/kaeru/Cargo.* ./kaeru/
RUN sed -i 's#src/main.rs#dummy.rs#' Cargo.toml && \
    sed -i 's#src/lib.rs#dummy.rs#' kaeru/Cargo.toml && \
    cargo build --release && \
    rm -rf ./src ./kaeru ./Cargo.*

COPY ./docker/kawa/error.flac /
COPY ./docker/kawa/config.toml /config.toml

RUN sed -i "s%name=\"radio\"%name=\"${KAWA_STREAM_NAME}\"%g" /config.toml && \
    sed -i "s%KAWA_RANDOM_SONG_URL%${KAWA_RANDOM_SONG_URL}%g" /config.toml && \
    sed -i "s%KAWA_NEXT_RANDOM_URL%${KAWA_NEXT_RANDOM_URL}%g" /config.toml && \
    sed -i "s%KAWA_NOW_PLAYING_URL%${KAWA_NOW_PLAYING_URL}%g" /config.toml && \
    sed -i "s%port=4040%port=${KAWA_API_PORT}%g" /config.toml && \
    sed -i "s%port=8001%port=${KAWA_STREAM_PORT}%g" /config.toml

COPY ./services/kawa .
# Code no longer needed
RUN cargo install --path . --locked --verbose --root /usr && \
    rm -rf /usr/src/kawa



EXPOSE ${KAWA_API_PORT}
EXPOSE ${KAWA_STREAM_PORT}

WORKDIR /
ENTRYPOINT ["/usr/bin/kawa", "/config.toml"]

HEALTHCHECK --interval=30s --timeout=15s --retries=3 --start-period=5m \
    CMD curl --fail http://127.0.0.1:${KAWA_API_PORT}/np | jq --exit-status -r '.hash' || exit 1