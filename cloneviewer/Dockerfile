FROM jupyter:cloneviewer-intermediate
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"

WORKDIR /tmp
RUN \
    git clone https://github.com/krinsman/notebook-clone-extension.git	&&  \
    cd notebook-clone-extension							&&  \
    pip install -e .								&&  \
    jupyter serverextension enable notebook_clone_extension --sys-prefix --system	&&  \
    cd ../nbviewer	    	   			    		 		&&  \
    pip install -e .			

RUN \
    # want to use this with JupyterLab + JupyterHub, not just classic notebook servers
    conda install jupyterlab --yes     	 	     	      	      	       &&  \
    jupyter labextension install @jupyterlab/hub-extension

WORKDIR /srv
RUN \
    rm jupyterhub_config.py
ADD jupyterhub_config.py .