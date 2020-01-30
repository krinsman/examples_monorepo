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
    curl -s -o miniconda3.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh    &&  \
    bash miniconda3.sh -f -b -p /opt/anaconda3							      &&  \
    echo "python 3.7.*" >> /opt/anaconda3/conda-meta/pinned					      &&  \
    /opt/anaconda3/bin/conda clean --all --yes							      &&  \
    rm -rf /opt/anaconda3/pkgs/*   	 							      &&  \
#
# add dummy users
#
    $imageUtils add_users									      &&  \
#
# Clean up after ourselves
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
#    jupyter labextension install @jupyterlab/hub-extension@0.12.0 --clean --no-build	&&  \
    jupyter lab clean	 	 			   	   			&&  \
    jlpm cache clean									&&  \
    npm cache clean --force								&&  \
# Clean up after ourselves
    rm -rf *

WORKDIR /srv
