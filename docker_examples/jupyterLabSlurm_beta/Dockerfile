# most recent LTS at time this Dockerfile was written
FROM ubuntu:bionic
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"

ARG imageUtils=./utils.sh

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

# Timezone to Berkeley
ENV TZ=America/Los_Angeles
RUN \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  &&  \
    echo $TZ > /etc/timezone	    		    

WORKDIR /tmp

ADD $imageUtils .
RUN \
    chmod +x $imageUtils				    &&  \
#
# Base Ubuntu packages
#
    $imageUtils apt_install    			    	\
    bzip2	 					\
    curl						\
    # this will fail without ca-certificates
    # because of the --no-install-recommends flag
    # also curl seems to need it now to download miniconda script b/c of permissions/authentication
    # maybe that's new to the repo.anaconda.com URL vs the old repo.continuum.io URL -- I don't know
    ca-certificates					\
    libffi-dev						\
    lsb-release						\
    tzdata						\
    wget					    &&  \
#
# Clone repos to non-temp folder so we can edit them later
#
    mkdir /repos				    &&  \
#
# Install Miniconda
#
    # URL needed to be updated to repo.anaconda.com from repo.continuum.io -- curl doesn't handle redirects?
    # as another option -L flag was supposed to allow curl to follow redirects,
    # but even with that flag and old URL curl still seems to fail silently and not download the script
    # I guess mabye because authentication is being used, which would also explain the need for ca-certificates for this to work
    # https://stackoverflow.com/questions/18474690/is-there-a-way-to-follow-redirects-with-command-line-curl#comment41186114_18474746
    curl -s -o miniconda3.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh    &&  \
    # in any case using new URL seems stabler than assuming redirect from old URL to new URL will last forever
    bash miniconda3.sh -f -b -p /opt/anaconda3							      &&  \
    /opt/anaconda3/bin/conda clean --all --yes							      &&  \
    rm -rf /opt/anaconda3/pkgs/*   	 							      &&  \
#
# add dummy users
#
    $imageUtils add_users									      &&  \
#
# Clean up after ourselves: prevent cruft in /tmp directory from increasing image layer size
#
    rm -rf *
    
# Use conda to install packages
ENV PATH=/opt/anaconda3/bin:$PATH

ADD environment.yml .

RUN \
    conda config --add channels conda-forge						&&  \
    conda env update --name base --file environment.yml					&&  \
    conda clean --all --yes								&&  \
    rm -rf /opt/anaconda3/pkgs/*							&&  \
    pip install --no-cache-dir jupyterlab_slurm==2.0.0					&&  \
    jupyter labextension install jupyterlab-slurm@2.0.0					&&  \
    jupyter lab clean	 	 			   	   			&&  \
    jlpm cache clean									&&  \
    npm cache clean --force								&&  \
# Clean up after ourselves
    rm -rf *

# Try to do minimal install of Slurm for local JupyterLab-Slurm testing
ADD $imageUtils .
RUN chmod +x $imageUtils && $imageUtils apt_install slurmd slurm-client slurmctld

WORKDIR /srv
