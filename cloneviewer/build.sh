#!/bin/bash

docker build    \
    --file=../nbviewer/Dockerfile  \
    --no-cache  \
    --build-arg branch=master  \
    --build-arg repository=krinsman  \
    --tag jupyter:cloneviewer-intermediate  ../nbviewer

docker build    \
    --no-cache  \
    --tag jupyter:cloneviewer .
