#!/bin/bash

# Create a TCP proxy that let's us access the PostgresSQL db at
# localhost:5432
socat TCP-LISTEN:5432,reuseaddr,fork TCP:datamodel_psql_db:5432 &

# active our python virtualenv, and start the notebook server
# since this service should only be accessible from localhost,
# we'll ignore passwords and running from root
. /opt/venv/bin/activate && jupyter notebook \
	--port=8888 \
	--no-browser \
	--allow-root \
	--ip='0.0.0.0' \
	--NotebookApp.token='' \
	--NotebookApp.password=''

