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

# Add necessary config files
WORKDIR /srv
ADD jupyterhub_config.py .
