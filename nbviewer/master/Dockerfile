#### WARNING:
#### This assumes the repository root directory is the Docker build context

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
# needed for git push to work
    ca-certificates                         \
    git					&&  \
# Add dummy users
    ./utils.sh add_users		&&  \
# Clean up after ourselves
    rm -rf /tmp/*

# Change to directory from which JupyterHub will be run and add necessary config files
WORKDIR /srv
ADD nbviewer/master/jupyterhub_config.py .
