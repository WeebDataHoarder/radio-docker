#!/bin/bash

source .env

docker-compose exec --env PGPASSWORD="${DB_PASSWORD}" db psql --host db --username "${DB_USER}" "$@" "${DB_NAME}"

