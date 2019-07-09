#!/bin/bash

# Check to see whether base image already exists; if it doesn't, then build it
export baseDockerImage="jupyter:labhub"
  
if ! docker inspect "$baseDockerImage" &> /dev/null; then
    docker build                     \
           --file=../Dockerfile      \
	   --tag $baseDockerImage    \
	   ..
fi

# Make Docker build context the repository root
cd ..

docker build                         \
       --file=resuse/Dockerfile      \
       --no-cache                    \
       --tag resuse                  \
       .

# Delete all intermediate images with label autodelete=true
#
# From: https://github.com/moby/moby/issues/34151#issuecomment-478802490
list=$(docker images -q -f "dangling=true" -f "label=autodelete=true")
if [ -n "$list" ]; then
     docker rmi $list
fi
