#### WARNING: This Dockerfile assumes the build context is the directory where this Docker file is located
#### and NOT the repository root directory (i.e. unlike every other Dockerfile in the repository)

FROM continuumio/miniconda3 AS tomopy_base

WORKDIR /tmp

COPY ./weak_pinned_environment.yml ./environment.yml
# If using the pinned environment doesn't work, i.e. it can't be resolved, try instead
# COPY ./environment.yml ./environment.yml
# If above does work but unable to reproduce the environment, try (very slow)
# COPY ./strong_pinned_environment.yml ./environment.yml

# get tomopy software files from GitHub
RUN apt-get install git ca-certificates --yes --no-install-recommends     &&  \
    apt-get clean --yes			      				  &&  \
    git clone https://github.com/krinsman/jupyterhub-deploy.git           &&  \
    git clone https://github.com/tomopy/tomopy.git /repos/tomopy	  &&  \
    cd /repos/tomopy							  &&  \
    git checkout b5789d52ab4bf0818fd2632b891e5a9c5180af51
# Install all necessary packages from conda
RUN conda env update --name base --file /tmp/environment.yml		  &&  \
    conda clean --all --yes -f						  &&  \
    rm -rf /opt/conda/pkgs/*

FROM ubuntu:bionic

RUN apt-get update							  &&  \
    apt-get install vim git ca-certificates --yes --no-install-recommends &&  \
    apt-get clean --yes
# Multi-stage build for hopefully smaller final image size
COPY --from=tomopy_base /repos /repos
COPY --from=tomopy_base /opt /opt
# Need to copy this over for conda config to transfer, in particular environment variables e.g. $CONDA_PREFIX
# without this step the ./link.sh step doesn't work since ~/.bashrc won't have the necessary info
COPY --from=tomopy_base /root /root

ENV PATH=/opt/conda/bin:$PATH
WORKDIR /tmp
# Setup compilers and install tomopy
COPY ./link.sh ./link.sh
RUN chmod +x link.sh
RUN ["/bin/bash", "./link.sh"]
RUN rm -rf /tmp/*

WORKDIR /repos
# Add notebook
COPY ./phantom.ipynb ./phantom.ipynb
