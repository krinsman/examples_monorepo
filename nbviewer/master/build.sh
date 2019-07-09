#!/bin/bash

export repositoryRoot=../..

# Make Docker build context the repository root
cd $repositoryRoot

# If it wasn't executable before... it is now
chmod +x useful_functions.sh

# Check to see whether base image already exists; if it doesn't, then build it
./useful_functions.sh if_not_base_image_then_build_it

docker build                           \
    --file=nbviewer/Dockerfile         \
    --force-rm                         \
    --no-cache                         \
    --build-arg branch=master          \
    --build-arg repository=jupyter     \
    --tag nbviewer_base                \
    .

docker build                           \
    --file=nbviewer/master/Dockerfile  \
    --force-rm                         \
    --no-cache                         \
    --tag jupyter:nbviewer             \
    .

# Delete all intermediate images with label autodelete=true
./useful_functions.sh destroy_intermediates
