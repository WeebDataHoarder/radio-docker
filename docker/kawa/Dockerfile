FROM golang:1.18-bullseye

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

RUN groupadd -r kawa && useradd -r -g kawa kawa && \
    DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    jq curl \
    git build-essential autoconf automake libtool \
    libflac-dev libopus-dev libopusfile-dev libsamplerate0-dev libmp3lame-dev libebur128-dev && \
    git clone --depth 1 https://github.com/xiph/libopusenc.git && cd libopusenc && \
    ./autogen.sh && \
    ./configure --prefix /usr &&  \
    make &&  \
    make install &&  \
    cd .. && \
    git clone --depth 1 https://github.com/mstorsjo/fdk-aac.git && cd fdk-aac  && \
    ./autogen.sh &&  \
    ./configure --prefix /usr && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf /src/libopusenc /src/fdk-aac

COPY ./docker/kawa/error.flac /
COPY ./docker/kawa/config.toml /config.toml

RUN sed -i "s%name=\"radio\"%name=\"${KAWA_STREAM_NAME}\"%g" /config.toml && \
    sed -i "s%description=\"\"%description=\"${KAWA_STREAM_DESCRIPTION}\"%g" /config.toml && \
    sed -i "s%KAWA_RANDOM_SONG_URL%${KAWA_RANDOM_SONG_URL}%g" /config.toml && \
    sed -i "s%KAWA_NEXT_RANDOM_URL%${KAWA_NEXT_RANDOM_URL}%g" /config.toml && \
    sed -i "s%KAWA_NOW_PLAYING_URL%${KAWA_NOW_PLAYING_URL}%g" /config.toml && \
    sed -i "s%port=4040%port=${KAWA_API_PORT}%g" /config.toml && \
    sed -i "s%port=8001%port=${KAWA_STREAM_PORT}%g" /config.toml

COPY ./services/MeteorLight .
RUN go build -buildvcs=false -v -o /usr/bin/MeteorLight . && rm -rf /code

USER kawa

EXPOSE ${KAWA_API_PORT}
EXPOSE ${KAWA_STREAM_PORT}

WORKDIR /
ENTRYPOINT ["/usr/bin/MeteorLight"]

HEALTHCHECK --interval=30s --timeout=15s --retries=3 --start-period=5m \
    CMD curl --fail http://127.0.0.1:${KAWA_API_PORT}/np | jq --exit-status -r '.hash' || exit 1