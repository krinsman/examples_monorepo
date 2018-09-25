FROM ubuntu:16.04
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"

# Base Ubuntu packages.
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
# Make sure the Ubuntu image is up-to-date.
RUN \
    apt-get update          &&  \
    apt-get --yes upgrade   &&  \
    apt-get --yes install       \
        bzip2                   \
        curl                    \
        git                     \
        libffi-dev              \
        lsb-release             \
        tzdata                  \
        vim                     \
        wget

# Set timezone to Berkeley
ENV TZ=America/Los_Angeles
RUN \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  &&  \
    echo $TZ > /etc/timezone

# Sets the pwd when you enter into the container
WORKDIR /tmp

# Add the Miniconda install shell script to the docker container
ADD Miniconda3-latest-Linux-x86_64.sh .
# Make it executable 
RUN chmod +x Miniconda3-latest-Linux-x86_64.sh
# Remember to choose /opt/anaconda as the install directory when 
# running the install script so that the below steps work.

# Add the shell script in the directory to the Docker container
ADD reproduce.sh .
# Make it executable
RUN chmod +x reproduce.sh

# Set up BASH settings to work with conda:
RUN \
    echo ". /opt/anaconda/etc/profile.d/conda.sh" >> ~/.bashrc         && \
    echo "conda activate" >> ~/.bashrc                                 
# Add conda to the path
ENV PATH=/opt/anaconda/bin:$PATH

# Create an alias so that running notebook from the container isn't such a pain.
# You shouldn't have to do anything analogous on your real machine.
RUN echo "alias jupyter=\"jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root\"" >> ~/.bashrc