FROM node:13.3.0-alpine3.10

RUN apk update && apk add python3 make g++ bash

RUN mkdir -p /builder

WORKDIR /builder

COPY package.json package-lock.json /builder/

RUN npm ci --no-optional

COPY gulpfile.js define_user.sh /builder/
