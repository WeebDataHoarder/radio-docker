#!/bin/bash

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

while ! pg_isready --dbname "postgres://${DB_USER}:${DB_PASSWORD}@db/${DB_NAME}"; do
    echo "$(date) - waiting for database to start"
    sleep 1
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