FROM ubuntu:16.04
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"

# Base Ubuntu packages
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

RUN \
    apt-get update		  &&  \
    apt-get --yes upgrade   	  &&  \
    apt-get --yes install	      \
        bzip2			      \
        curl			      \
        git                           \
        libffi-dev                    \
        lsb-release                   \
        tzdata                        \
        vim                           \
        wget		 	      \
	libmemcached-dev	      \
	libcurl4-openssl-dev	      \
	libevent-dev

# Timezone to Berkeley
ENV TZ=America/Los_Angeles
RUN \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  &&  \
    echo $TZ > /etc/timezone

# Install Miniconda
RUN \
    curl -s -o /tmp/miniconda3.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh    &&  \
    bash /tmp/miniconda3.sh -f -b -p /opt/anaconda3							   &&  \
    rm -rf /tmp/miniconda3.sh										   &&  \
    echo "python 3.7.*" >> /opt/anaconda3/conda-meta/pinned

ENV PATH=/opt/anaconda3/bin:$PATH

# Use conda to install packages
RUN \
    conda update --yes conda															    &&  \
    conda config --add channels conda-forge													    &&  \
    conda install --yes																	\
        alembic																		\
        cryptography    																\
        decorator																	\
        entrypoints     																\
        jinja2          																\
        mako            																\
        markupsafe      																\
        nodejs          																\
        oauthlib=2      																\
        pamela																		\
        psycopg2        																\
        pyopenssl																	\
        python-dateutil 																\
        python-editor   																\
        sqlalchemy      																\
        tornado																		\
        traitlets																	\
	jupyter																		\
	nbconvert																	\
	pycurl																		\
	setuptools																	\
	markdown																	\
	pandoc																		\
	invoke																		\
	elasticsearch																	\
	jupyterhub																	\
	pylibmc																		\
	statsd																		\
	newrelic																        \
	jupyterlab																    &&  \
    jupyter labextension install @jupyterlab/hub-extension --clean

# add some dummy users
RUN \
    adduser -q --gecos "" --disabled-password william			&&  \
    echo william:hi   | chpasswd
    
RUN \
    adduser -q --gecos "" --disabled-password krinsman			&&  \
    echo krinsman:bye | chpasswd
