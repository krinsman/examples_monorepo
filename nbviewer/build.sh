#!/bin/bash

docker build    \
    --no-cache  \
    --build-arg branch=master  \
    --build-arg repository=jupyter  \
    --tag jupyter:nbviewer .
