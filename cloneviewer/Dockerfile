FROM jupyter:cloneviewer-intermediate
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"

WORKDIR /tmp
RUN \
    git clone https://github.com/krinsman/notebook-clone-extension.git		&&  \
    cd notebook-clone-extension							&&  \
    pip install -e .								&&  \
    jupyter serverextension enable clonenotebooks.cloners --sys-prefix 		&&  \
    cd ../nbviewer	    	   			    		 	&&  \
    pip install -e .			

RUN \
    # want to use this with JupyterLab + JupyterHub, not just classic notebook servers
    conda install jupyterlab --yes     	 	     	      	      	       &&  \
    jupyter labextension install @jupyterlab/hub-extension

WORKDIR /media
RUN mkdir templates
ADD templates ./templates

WORKDIR /srv
RUN \
    rm jupyterhub_config.py
ADD jupyterhub_config.py .
ADD nbviewer_config.py .
