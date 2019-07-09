#!/bin/bash

# Check to see whether base image already exists; if it doesn't, then build it
export dockerImage="jupyter:labhub"
  
if ! docker inspect "$dockerImage" &> /dev/null; then
    docker build                 \
           --file=../Dockerfile  \
	   --tag jupyter:labhub  \
	   ..
fi

docker build                                 \
     --no-cache                              \
     --force-rm                              \
     --build-arg branch=copy-to-user-server  \
     --build-arg repository=danielballan     \
     --tag jupyter:dballanbviewer            \
     .
