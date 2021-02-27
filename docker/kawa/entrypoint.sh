#!/bin/bash

echo "[api]" > /config.toml
echo "host=\"0.0.0.0\"" >> /config.toml
echo "port=${KAWA_API_PORT}" >> /config.toml
echo "[queue]" >> /config.toml
echo "random_song_api=\"${KAWA_RANDOM_SONG_URL}?apikey=${DEFAULT_API_KEY}\"" >> /config.toml
echo "nr=\"${KAWA_NEXT_RANDOM_URL}\"" >> /config.toml
echo "np=\"${KAWA_NOW_PLAYING_URL}\"" >> /config.toml
echo "fallback=\"/error.flac\"" >> /config.toml

echo "[radio]" >> /config.toml
echo "port=${KAWA_STREAM_PORT}" >> /config.toml
echo "name=\"${KAWA_STREAM_NAME}\"" >> /config.toml
cat << EOF >> /config.toml
[[streams]]
mount="stream192.mp3"
container="mp3"
bitrate=192

[[streams]]
mount="stream64.ogg"
container="ogg"
codec="opus"
bitrate=64

[[streams]]
mount="stream64.aac"
container="aac"
codec="aac"
bitrate=64

[[streams]]
mount="stream128.aac"
container="aac"
codec="aac"
bitrate=128

[[streams]]
mount="stream256.aac"
container="aac"
codec="aac"
bitrate=256

[[streams]]
mount="stream128.ogg"
container="ogg"
codec="opus"
bitrate=128

[[streams]]
mount="stream256.ogg"
container="ogg"
codec="opus"
bitrate=256

[[streams]]
mount="stream.flac"
container="flac"
EOF

RUST_BACKTRACE=full RUST_LOG=${KAWA_LOG} /usr/bin/kawa /config.toml