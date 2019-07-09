#### WARNING:
#### This assumes the repository root directory is the Docker build context

FROM jupyter:labhub AS nbviewer_base
LABEL maintainer="William Krinsman <krinsman@berkeley.edu"
LABEL autodelete="true"

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

