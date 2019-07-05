FROM jupyter:labhub
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"

# build JupyterLab since it's not built in base image
# since other child images have their own JupyterLab extensions they might install
RUN \
    jupyter lab build

# Install nbviewer
WORKDIR /tmp
ARG repository
ARG branch
RUN \
    git clone --single-branch --branch $branch https://github.com/$repository/nbviewer.git		    &&  \
    cd nbviewer								    				    &&  \
    pip install -e .	          				    				            &&  \
    npm install	   							    				    &&  \
    invoke bower							    				    &&  \
    invoke less

# Add necessary config files
WORKDIR /srv
ADD jupyterhub_config.py .