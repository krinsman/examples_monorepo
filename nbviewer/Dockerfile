#### WARNING:
#### This assumes the repository root directory is the Docker build context

FROM jupyter:labhub AS nbviewer_base
#LABEL autodelete="true"

# Build arguments for installing nbviewer
ARG repository
ARG branch

WORKDIR /tmp
ADD utils.sh .
ADD nbviewer/environment.yml .

RUN \
    chmod +x utils.sh											    &&  \
# LabHub extension wasn't built in jupyter:labhub
    jupyter lab build											    &&  \
#
# Install nbviewer dependencies
#
    ./utils.sh apt_install											\
    libmemcached-dev												\
    libcurl4-openssl-dev											\
    libevent-dev											    &&  \
    conda env update --name base --file environment.yml							    &&  \
    conda clean --all --yes										    &&  \
    rm -rf /opt/anaconda3/pkgs/*									    &&  \
#
# Install nbviewer
#
    apt-get install --yes git										    &&  \
    git clone --single-branch --branch $branch https://github.com/$repository/nbviewer.git /repos/nbviewer  &&  \
    cd /repos/nbviewer								    			    &&  \
    pip install -e . --no-cache-dir					    				    &&  \
    npm install   							    				    &&  \
    invoke bower							    				    &&  \
    invoke less												   

#### FINAL IMAGE

FROM ubuntu:bionic
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"

COPY --from=nbviewer_base /repos /repos
COPY --from=nbviewer_base /opt /opt

ENV PATH=/opt/anaconda3/bin:$PATH  \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8  		   \
#
# Timezone to Berkeley
#
    TZ=America/Los_Angeles
RUN \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  &&  \
    echo $TZ > /etc/timezone

WORKDIR /tmp
ADD utils.sh .
RUN \
    chmod +x utils.sh			&&  \
#
# Install utils
#
    ./utils.sh apt_install		    \
    vim	       				    \
    git					&&  \
# Add dummy users
    ./utils.sh add_users		&&  \
# Clean up after ourselves
    rm -rf /tmp/*

# Change to directory from which JupyterHub will be run and add necessary config files
WORKDIR /srv
ADD nbviewer/jupyterhub_config.py .