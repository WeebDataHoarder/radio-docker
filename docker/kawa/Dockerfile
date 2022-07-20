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

ENV CFLAGS="-march=native -Ofast -flto"
ENV CXXFLAGS="-march=native -Ofast -flto"
ENV LDFLAGS="-flto"
ENV CGO_CFLAGS="-march=native -Ofast"

WORKDIR /usr/src/kawa

RUN groupadd -r kawa && useradd -r -g kawa kawa && \
    DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    jq curl \
    git build-essential autoconf automake cmake make libtool libtool-bin gettext \
    libssl-dev && \
    git clone --depth 1 --branch 0.2.2 https://github.com/libsndfile/libsamplerate.git && cd libsamplerate && \
    ./autogen.sh && \
    ./configure --prefix /usr &&  \
    make &&  \
    make install && \
    cd .. && \
    git clone --depth 1 --branch v1.2.6 https://github.com/jiixyj/libebur128.git && cd libebur128 && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON -DCMAKE_BUILD_TYPE=Release &&  \
    make &&  \
    make install && \
    cd ../.. && \
    wget https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz -O lame-3.100.tar.gz && \
    tar -xzvf lame-3.100.tar.gz && \
    cd lame-3.100 && \
    ./configure --prefix /usr &&  \
    make &&  \
    make install && \
    cd .. && \
    git clone --depth 1 --branch v1.3.5 https://github.com/xiph/ogg.git && cd ogg && \
    ./autogen.sh && \
    ./configure --prefix /usr &&  \
    make &&  \
    make install && \
    cd .. && \
    git clone --branch master https://github.com/xiph/opus.git && cd opus && \
    ./autogen.sh && \
    ./configure --enable-float-approx --prefix /usr &&  \
    make &&  \
    make install && \
    cd .. && \
    git clone --depth 1 --branch v0.12 https://github.com/xiph/opusfile.git && cd opusfile && \
    ./autogen.sh && \
    ./configure --prefix /usr &&  \
    make &&  \
    make install && \
    cd .. && \
    git clone --depth 1 --branch master https://github.com/xiph/libopusenc.git && cd libopusenc && \
    ./autogen.sh && \
    ./configure --prefix /usr &&  \
    make &&  \
    make install && \
    cd .. && \
    git clone --depth 1 --branch 1.3.4 https://github.com/xiph/flac.git && cd flac && \
    ./autogen.sh && \
    ./configure --prefix /usr &&  \
    make &&  \
    make install && \
    cd .. && \
    git clone --depth 1 https://github.com/mstorsjo/fdk-aac.git && cd fdk-aac  && \
    ./autogen.sh &&  \
    ./configure --prefix /usr && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    git clone --depth 1 https://git.gammaspectra.live/S.O.N.G/alac.git && cd alac  && \
    autoreconf -fi &&  \
    ./configure --prefix /usr && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf /src/libsamplerate /src/libebur128 /src/lame-3.100 /src/ogg /src/opus /src/opusfile /src/flac /src/libopusenc /src/fdk-aac /src/alac

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