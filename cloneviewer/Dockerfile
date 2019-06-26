FROM jupyter:labhub
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"

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

# Install notebook cloning extension
WORKDIR /tmp
RUN \
    git clone https://github.com/krinsman/clonenotebooks.git			&&  \
    cd clonenotebooks								&&  \
    pip install -e .								&&  \
    jupyter serverextension enable clonenotebooks.cloners --sys-prefix 		&&  \
    cd ../nbviewer	    	   			    		 	&&  \
    pip install -e .			

# Add necessary config files
WORKDIR /srv
ADD jupyterhub_config.py .
ADD nbviewer_config.py .
