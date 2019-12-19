#!/bin/bash

. version

docker build --rm -f "Dockerfile" -t sebbia-antora-builder:latest .

docker tag sebbia-antora-builder:latest sebbia-antora-builder:${SEBBIA_ANTORA_VERSION}