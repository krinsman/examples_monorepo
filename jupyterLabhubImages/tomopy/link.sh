#!/bin/bash

# need this or else nothing works,
# since without it the Docker container is oblivious of environment variables apparently
# and the pip install command requires $CC be defined in order to use CMake
source ~/.bashrc
# seriously I lost hours of my life figuring this out

echo $CONDA_PREFIX

ln -s $CC $CONDA_PREFIX/bin/gcc
ln -s $CXX $CONDA_PREFIX/bin/g++

cd /repos/tomopy
pip install -e . --install-option="--disable-cuda" --install-option="--disable-tasking" --no-cache-dir
