#!/bin/bash

. config

docker build --rm -f "Dockerfile" -t ${IMAGE_NAME}:latest .

docker tag ${IMAGE_NAME}:latest ${IMAGE_NAME}:${BUILDER_VERSION}