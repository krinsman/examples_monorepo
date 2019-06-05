#!/bin/bash

docker build    \
    --file=../nbviewer/Dockerfile  \
    --no-cache  \
    --build-arg branch=copy-to-user-server  \
    --build-arg repository=danielballan  \
    --tag jupyter:dballanbviewer-intermediate  ../nbviewer

docker build    \
    --no-cache  \
    --tag jupyter:dballanbviewer .
