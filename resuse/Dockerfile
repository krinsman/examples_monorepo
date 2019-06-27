FROM jupyter:labhub
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"

# install additional dependency
RUN \
    conda install psutil --yes

# install jupyterlab_resuse
WORKDIR /tmp
RUN \
    git clone https://github.com/krinsman/jupyterlab_resuse.git   &&  \
    cd jupyterlab_resuse					  &&  \
    pip install -e .						  &&  \
    jupyter serverextension enable jupyterlab_resuse --sys-prefix &&  \
    jlpm install 	    	   		     		  &&  \
    jlpm run build						  &&  \
    jupyter labextension install . --clean                        &&  \
    rm -rf /tmp/npm*/ /tmp/v8-compile-cache-0/

# change to directory from which JupyterHub will be run
WORKDIR /srv
ADD jupyterhub_config.py .
