FROM jupyter:dballanbviewer-intermediate
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"

# Install Daniel Allan's experimental notebook-sharing extension
WORKDIR /tmp
RUN \
    git clone https://github.com/danielballan/notebook-clone-extension.git	&&  \
    cd notebook-clone-extension							&&  \
    pip install -e .								&&  \
    jupyter serverextension enable notebook_clone_extension --sys-prefix --system			

RUN \
    # want to use this with JupyterLab + JupyterHub, not just classic notebook servers
    conda install jupyterlab --yes     	 	     	      	      	       &&  \
    jupyter labextension install @jupyterlab/hub-extension

WORKDIR  /srv
RUN \
    rm jupyterhub_config.py
ADD jupyterhub_config.py .