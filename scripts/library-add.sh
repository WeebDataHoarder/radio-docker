#!/bin/bash

docker-compose exec --workdir /usr/src/stewdio-api api python -m stewdio.library add "$@"