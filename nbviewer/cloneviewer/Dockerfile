#### WARNING:
#### This assumes the repository root directory is the Docker build context

FROM nbviewer_base as cloneviewer_base
LABEL maintainer="William Krinsman <krinsman@berkeley.edy>"
LABEL autodelete="true"

# Install notebook cloning extension
WORKDIR /tmp
RUN \
    git clone https://github.com/krinsman/clonenotebooks.git /repos/clonenotebooks	&&  \
    cd /repos/clonenotebooks								&&  \
    pip install -e . --no-cache-dir							&&  \
    jupyter serverextension enable clonenotebooks.cloners --sys-prefix

#### FINAL IMAGE

FROM ubuntu:bionic
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"

ARG imageUtils=./utils.sh

COPY --from=cloneviewer_base /repos /repos
COPY --from=cloneviewer_base /opt /opt
# Need to copy this for conda config settings to transfer, e.g. conda-forge as main channel
# because I was too lazy to create another user besides root for the settings to go with
COPY --from=resuse_base /root /root

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
ADD $imageUtils .
RUN \
    chmod +x $imageUtils		&&  \
#
# Install utils
#
    $imageUtils apt_install		    \
    vim	       				    \
    # needed for git push to work
    ca-certificates                         \
    git					&&  \
# Add dummy users
    $imageUtils add_users		&&  \
# Clean up after ourselves
    rm -rf /tmp/*

# Add necessary config files
WORKDIR  /srv
ADD nbviewer/cloneviewer/jupyterhub_config.py .
ADD nbviewer/cloneviewer/nbviewer_config.py   .
