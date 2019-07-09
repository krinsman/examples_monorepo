#### WARNING:
#### This assumes the repository root directory is the Docker build context

FROM jupyter:labhub AS resuse_base
LABEL autodelete="true"

WORKDIR /tmp

# install additional dependency
ADD resuse/environment.yml .

RUN \
    apt-get install --yes git								    &&  \
    conda env update --name base --file environment.yml					    &&  \
    conda clean --all --yes								    &&  \
    rm -rf /opt/anaconda3/pkgs/*							    &&  \
#
# install jupyterlab_resuse
#
    git clone https://github.com/krinsman/jupyterlab_resuse.git /repos/jupyterlab_resuse   &&  \
    cd /repos/jupyterlab_resuse					  	            &&  \
    pip install -e . --no-cache-dir							    &&  \
    jupyter serverextension enable jupyterlab_resuse --sys-prefix 			    &&  \
    cd /repos/jupyterlab_resuse   		      					    &&  \
    jlpm install 	    	   		     		  			    &&  \
    jlpm run build						  			    &&  \
    jupyter labextension install . --clean   						    &&  \
    jupyter lab clean									    &&  \
    jlpm cache clean									    &&  \
    npm cache clean --force								    

#### FINAL IMAGE

FROM ubuntu:bionic
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"

ARG imageUtils=./utils.sh

COPY --from=resuse_base /repos /repos
COPY --from=resuse_base /opt   /opt

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
    chmod +x $imageUtils    &&  \
#
# Install utils
    $imageUtils apt_install	\
# needed for git push to work
    ca-certificates             \
    git				\
    vim 		    &&  \
#
# Add dummy users
    $imageUtils add_users   &&  \
# Clean up after ourselves
    rm -rf /tmp/*

# change to directory from which JupyterHub will be run
WORKDIR /srv
ADD resuse/jupyterhub_config.py .
