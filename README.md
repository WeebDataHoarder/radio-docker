# radio-docker
Glue and linkage of all projects to work together.

### Requirements
* `docker`
* `docker-compose`

### Usage
* `$ git clone --recursive https://github.com/WeebDataHoarder/radio-docker.git`
* `$ cp .env.example .env`, then edit `.env` to fit your needs. This is the main configuration file.
* Build/Upgrade: `$ git clone update --init --recursive && docker-compose build`
* Start `$ docker-compose up` (`$ docker-compose up -d` for detached)
* Stop `$ docker-compose stop`

### Utilities
* `scripts/psql.sh`: Opens a Postgres CLI session with the running database.
* `scripts/library-add.sh PATH`: Scans and adds _PATH_ to the music database library.