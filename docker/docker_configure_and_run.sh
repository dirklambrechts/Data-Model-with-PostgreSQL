#!/bin/bash
# Get the location of this script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd "${SCRIPT_DIR}"/../

# Build the docker image containing a jupyter notebook server and
# this repo's code
sudo docker build \
	-f ./docker/Dockerfile \
	-t datamodel_psql_jupyter \
	./

# Create a docker network to facilitate communication between
# the PostgreSQL server and the jupyter notebook
sudo docker network create datamodel_psql_net

# Run the PostgreSQL container
sudo docker run \
	--rm \
	--net datamodel_psql_net \
	--name datamodel_psql_db \
	-e POSTGRES_DB=studentdb \
	-e POSTGRES_USER=student \
	-e POSTGRES_PASSWORD=student \
	-d postgres

# Run the jupyter notebook container, that contains this repo's code
sudo docker run \
	--rm \
	--net datamodel_psql_net \
	--name datamodel_psql_jupyter \
	-it -p 127.0.0.1:8888:8888 --rm \
	datamodel_psql_jupyter

