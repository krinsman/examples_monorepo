#### WARNING:
#### This assumes the repository root directory is the Docker build context

FROM nbviewer_base as dballanbviewer_base
LABEL maintainer="William Krinsman <krinsman@berkeley.edy>"
LABEL autodelete="true"

# Install Daniel Allan's experimental notebook-sharing extension
WORKDIR /tmp
RUN \
    git clone https://github.com/danielballan/notebook-clone-extension.git /repos/notebook-clone-extension	&&  \
    cd /repos/notebook-clone-extension							                        &&  \
    pip install -e . --no-cache-dir								                &&  \
    jupyter serverextension enable notebook_clone_extension --sys-prefix			

#### FINAL IMAGE

FROM ubuntu:bionic
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"

ARG imageUtils=./utils.sh

COPY --from=dballanbviewer_base /repos /repos
COPY --from=dballanbviewer_base /opt /opt

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
ADD nbviewer/dballanbviewer/jupyterhub_config.py .
