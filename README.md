# Documentation builder with Antora, PlantUML and Black Jack

This is a basic features of this builder:

* Builds documentation with Antora
* Adds integration with PlantUML
* Adds live reload ability
* Adds full text search
* Provides possibility to build documentation in dockerized environment. This simplifies installation.

Build process is based on Gulp JS.

## Quick start

First you have to install `docker` and `docker-compose`.

Run this in terminal:
```sh
curl https://raw.githubusercontent.com/Sebbia/antora-builder/master/install.sh | bash
```

Clone and run sample documentation:
```sh
git clone https://github.com/Sebbia/antora-builder.git
sebbia-antora-builder watch -s antora-builder/example-docs -p antora-playbook.yml -o ~/doc-build
```

Open the documentation in a browser: http://localhost:3000.

## Usage with Docker

This is dependencies which have to be installed on the host system:
* Docker
* Docker Compose
* bash

Build with live reload and serving:
```sh
./sebbia-antora-builder.sh watch -s where/documentation/root/is -p where/playbook/is/relative/to/src.yml
```

After start the documentation can be viewed in a web browser at this URL: http://localhost:3000

Finally build can be performed by this command:
```sh
./sebbia-antora-builder.sh build -p where/playbook/is.yml -o where/to/place/html
```

## Directly builder usage without Docker

**WARNING:** This variant is harder for ordinary user. 

This is dependencies which have to be installed on the host system:
* node >= 12
* make
* g++
* python3

### Prepare step
```sh
$ cd ${project}
$ npm install
$ npx gulp build --playbook where/playbook/is.yml --output where/to/place/html
```

### Documentation build
```sh
$ cd ${project}
$ npx gulp build --playbook where/playbook/is.yml --output where/to/place/html
```

### Build with live reload and serving

```sh
$ cd ${project}
$ npx gulp watch --src where/documentation/root/is --playbook where/playbook/is.yml --output /where/to/place/html
```

The documentation is then accessible at http://localhost:3000.

## Adding search ability to the project

The search ability was implemented with this project https://github.com/Mogztter/antora-lunr.

In short, to enable search field you need to proceed this section:

https://github.com/Mogztter/antora-lunr#enable-the-search-component-in-the-ui

## Docker Hub Image

Images automatically built from this sources is located here:

https://hub.docker.com/r/sebbia/antora-builder