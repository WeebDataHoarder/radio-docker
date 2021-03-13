#!/bin/bash

docker-compose exec --user api --workdir /usr/src/stewdio-api api python -m stewdio.library addforce "$@"