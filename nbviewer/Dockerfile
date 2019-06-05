FROM ubuntu:16.04
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"


# Base Ubuntu packages

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

RUN \
    apt-get update          &&  \
    apt-get --yes upgrade   &&  \
    apt-get --yes install       \
        bzip2                   \
        curl                    \
        git                     \
        libffi-dev              \
        lsb-release             \
        tzdata                  \
        vim                     \
        wget			\
	libmemcached-dev	\
	libcurl4-openssl-dev	\
	libevent-dev

# Timezone to Berkeley

ENV TZ=America/Los_Angeles
RUN \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  &&  \
    echo $TZ > /etc/timezone

# Python 3 Miniconda and dependencies for JupyterHub we can get via conda


RUN \
    curl -s -o /tmp/miniconda3.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh    &&  \
    bash /tmp/miniconda3.sh -f -b -p /opt/anaconda3            &&  \
    rm -rf /tmp/miniconda3.sh                                  &&  \
    echo "python 3.7.*" >> /opt/anaconda3/conda-meta/pinned    &&  \
    /opt/anaconda3/bin/conda update --yes conda                &&  \
    /opt/anaconda3/bin/conda config --add channels conda-forge &&  \
    /opt/anaconda3/bin/conda install --yes                         \
        alembic         \
        cryptography    \
        decorator       \
        entrypoints     \
        jinja2          \
        mako            \
        markupsafe      \
        nodejs          \
        oauthlib=2      \
        pamela          \
        psycopg2        \
        pyopenssl       \
        python-dateutil \
        python-editor   \
        sqlalchemy      \
        tornado         \
        traitlets	\
	jupyter		\
	nbconvert	\
	pycurl		\
	setuptools	\
	markdown	\
	pandoc		\
	invoke		\
	elasticsearch	\
	jupyterhub	\
	pylibmc		\
	statsd		\
	newrelic


ENV PATH=/opt/anaconda3/bin:$PATH
WORKDIR /tmp
ARG repository
ARG branch
RUN \
    git clone --single-branch --branch $branch https://github.com/$repository/nbviewer.git		    &&  \
    cd nbviewer								    &&  \
    pip install -r requirements.txt					    &&  \
    npm install	   							    &&  \
    invoke bower							    &&  \
    invoke less

# add some dummy users
RUN \
    adduser -q --gecos "" --disabled-password william			    &&  \
    echo william:hi   | chpasswd
    
RUN \
    adduser -q --gecos "" --disabled-password krinsman			    &&  \
    echo krinsman:bye | chpasswd

WORKDIR /srv
ADD jupyterhub_config.py .