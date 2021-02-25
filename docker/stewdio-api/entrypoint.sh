#!/bin/bash

sed -i "s%sqlalchemy.url = postgres://localhost/music%sqlalchemy.url = postgres://${DB_USER}:${DB_PASSWORD}@db/${DB_NAME}%g" /usr/src/stewdio-api/alembic.ini

echo "[kawa]" > /usr/src/stewdio-api/stewdio-api.conf
echo "url = http://kawa:${KAWA_API_PORT}/" >> /usr/src/stewdio-api/stewdio-api.conf

cat << EOF >> /usr/src/stewdio-api/stewdio-api.conf
[postgres]
minconn = 1
maxconn = 50
database = ${DB_NAME}
user = ${DB_USER}
password = ${DB_PASSWORD}
host = db
port = 5432

[search]
off-vocal-regex = [^\w](w/o|without)[^\w].*[\)\]-]$|(karaoke|instrumental|acoustic|off vocal|vocal off|カラオケ)[・\s]*(カラオケ|バージョン)?(.*ver(sion|.)?)?\s*[->~～\])）]?[)\]]?\s*$

[storage-status]
main = ${DATA_MOUNT_PATH}

[acoustid]
api-key = ${ACOUSTID_API_KEY}
EOF

cd /usr/src/stewdio-api
source venv3/bin/activate
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

while ! pg_isready --dbname "postgres://${DB_USER}:${DB_PASSWORD}@db/${DB_NAME}"; do
    echo "$(date) - waiting for database to start"
    sleep 5
done

# Test if database exists, if not create
if ! PGPASSWORD="${DB_PASSWORD}" psql --host db --username "${DB_USER}" --command 'SELECT version_num FROM alembic_version LIMIT 1;' --tuples-only --no-align "${DB_NAME}"; then
  PYTHONPATH="." python contrib/init_db.py
  alembic stamp head
else
  # Do normal database upgrade on startup
  alembic upgrade head
fi

exec gunicorn -b 0.0.0.0:${STEWDIO_API_PORT} --threads ${STEWDIO_API_THREADS} --timeout 300 --worker-class flask_sockets.worker stewdio.app:app