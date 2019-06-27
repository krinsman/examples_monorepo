FROM jupyter:labhub
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"

RUN \
    jupyter lab build

# Install nbviewer
WORKDIR /tmp
ARG repository
ARG branch
RUN \
    git clone --single-branch --branch $branch https://github.com/$repository/nbviewer.git		    &&  \
    cd nbviewer								    				    &&  \
    pip install -r requirements.txt					    				    &&  \
    npm install	   							    				    &&  \
    invoke bower							    				    &&  \
    invoke less

# Install Daniel Allan's experimental notebook-sharing extension
WORKDIR /tmp
RUN \
    git clone https://github.com/danielballan/notebook-clone-extension.git	&&  \
    cd notebook-clone-extension							&&  \
    pip install -e .								&&  \
    jupyter serverextension enable notebook_clone_extension --sys-prefix			

# Add necessary config files
WORKDIR  /srv
ADD jupyterhub_config.py .
