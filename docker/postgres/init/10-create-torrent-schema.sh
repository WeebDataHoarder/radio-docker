#!/bin/bash

set -e
set -u

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -f /schema/torrents.sql "$DB_NAME_TORRENTS"