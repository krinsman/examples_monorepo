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
# install nbresuse, jupyterlab_resuse, topbar extensions
#
    git clone https://github.com/krinsman/nbresuse.git /repos/nbresuse			    &&  \
    cd /repos/nbresuse									    && \
    pip install -e . --no-cache-dir							    &&  \
    jupyter serverextension enable --py nbresuse --sys-prefix				    &&  \
    jupyter nbextension install --py nbresuse --sys-prefix				    &&  \
    jupyter nbextension enable --py nbresuse --sys-prefix				    &&  \
    cd /tmp										    &&  \
    git clone https://github.com/krinsman/jupyterlab_resuse.git /repos/jupyterlab_resuse    &&  \
    cd /repos/jupyterlab_resuse					  	            	    &&  \
    jlpm install 	    	   		     		  			    &&  \
    jlpm run build						  			    &&  \
    jupyter labextension install . --clean --no-build					    &&  \
    jupyter labextension install jupyterlab-topbar-extension --clean --no-build  	    &&  \
    jupyter labextension install jupyterlab-system-monitor --clean   			    &&  \
    jupyter lab clean									    &&  \
    jlpm cache clean									    &&  \
    npm cache clean --force								    

#### FINAL IMAGE

FROM ubuntu:bionic
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"

ARG imageUtils=./utils.sh

COPY --from=resuse_base /repos /repos
COPY --from=resuse_base /opt   /opt
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
# Give nbresuse custom memory limit calculator function to use
ADD resuse/jupyter_notebook_config.py /opt/anaconda3/etc/jupyter/jupyter_notebook_config.py
