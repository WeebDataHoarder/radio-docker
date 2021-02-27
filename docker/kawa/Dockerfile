FROM rust:1.50-buster

ARG KAWA_API_PORT=4040
ARG KAWA_STREAM_PORT=8001

WORKDIR /usr/src/kawa

RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    libmp3lame-dev libopus-dev libvorbis-dev \
    libavcodec-dev libavutil-dev libavformat-dev libavfilter-dev libavdevice-dev libswresample-dev libswscale-dev

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
COPY ./docker/kawa/entrypoint.sh /

COPY ./services/kawa .
# Code no longer needed
RUN cargo install --path . --locked --verbose --root /usr && rm -rf /usr/src/kawa

EXPOSE ${KAWA_API_PORT}
EXPOSE ${KAWA_STREAM_PORT}

WORKDIR /
ENTRYPOINT ["/entrypoint.sh"]