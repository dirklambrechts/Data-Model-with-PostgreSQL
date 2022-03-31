FROM ubuntu:latest

# Install required programs from apt
# Most of these options are added to block any interactive requests in the
# installation process
RUN DEBIAN_FRONTEND=noninteractive apt-get update  \
	&& DEBIAN_FRONTEND=noninteractive apt-get install \
	--assume-yes \
	--quiet \
	--allow-unauthenticated \
	--allow-downgrades \
	--allow-remove-essential \
	--allow-change-held-packages \
	--option Dpkg::Options::="--force-confold" \
	git python3 python3-venv socat

COPY ./requirements.txt .

# Create python venv, update pip and install requirements
RUN python3 -m venv /opt/venv \
	&& . /opt/venv/bin/activate \
	&& pip install --upgrade pip \
	&& pip install --requirement requirements.txt

# Create a directory to store the repo's code and user output
RUN mkdir /src
WORKDIR /src

# Copy the code files into the docker image
COPY . .


# Add Tini. Tini operates as a process subreaper for jupyter. This prevents
# kernel crashes. See https://jupyter-notebook.readthedocs.io/en/stable/public_server.html
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

# Mark this port as exposable
EXPOSE 8888

# Run a script to start the jupyter notebook
CMD ["/src/docker/start_jupyter_notebook.sh"]
