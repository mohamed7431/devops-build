#!/bin/bash
set -e
 
IMAGE_NAME=$1
IMAGE_TAG=$2
 
docker pull $IMAGE_NAME:$IMAGE_TAG
docker stop app || true
docker rm app || true
docker run -d --name app -p 80:80 $IMAGE_NAME:$IMAGE_TAG
