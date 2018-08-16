FROM ubuntu:16.04
LABEL maintainer="William Krinsman <williamkrinsman@lbl.gov>"

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
        wget

# Timezone to Berkeley

ENV TZ=America/Los_Angeles
RUN \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  &&  \
    echo $TZ > /etc/timezone

# Python 3 Miniconda and dependencies for JupyterHub we can get via conda

RUN \
    wget -q -O /tmp/miniconda3.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh    &&  \
    bash /tmp/miniconda3.sh -f -b -p /opt/anaconda3     &&  \
    rm -rf /tmp/anaconda3.sh                            &&  \
    /opt/anaconda3/bin/conda update --yes conda         &&  \
    /opt/anaconda3/bin/conda install --yes                  \
        decorator       \
        jinja2          \
        mako            \
        markupsafe      \
        nodejs          \
        psycopg2        \
        pycurl          \
        pyopenssl       \
        python-dateutil \
        sqlalchemy      \
        tornado         \
        traitlets

# Install JupyterHub

ENV PATH=/opt/anaconda3/bin:$PATH
WORKDIR /tmp

ARG CACHEBUST=1
RUN \
    npm install -g configurable-http-proxy                                            &&  \
    git clone https://github.com/krinsman/jupyterhub.git                              && \
    cd jupyterhub                                                                     &&  \
    /opt/anaconda3/bin/python setup.py js                                             &&  \
    /opt/anaconda3/bin/pip install .                                                  &&  \
    cp examples/cull-idle/cull_idle_servers.py /opt/anaconda3/bin/.                   &&  \
    chmod u+x /opt/anaconda3/bin/cull_idle_servers.py                                 &&  \
    rm -rf ~/.cache ~/.npm
