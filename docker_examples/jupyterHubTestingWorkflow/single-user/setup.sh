#!/bin/bash
docker build -t jupyterhub-base ./ --build-arg CACHEBUST=$(date +%s)
docker build -t jupyter/app:sshspawner ./app/
docker build -t jupyter/web:sshspawner ./web/
docker-compose up -d
