# Documentation builder with Antora, PlantUML and Black Jack

This is a basic features of this builder:

* Builds documentation with Antora
* Adds integration with PlantUML
* Adds live reload ability
* Provides possibility to build documentation in dockerized environment. This simplifies installation.

Build process is based on Gulp JS.

## Usage with Docker

This is dependencies which have to be installed on the host system:
* Docker
* Docker Compose
* bash

Build with live reload and serving:
```
./sebbia-antora-builder.sh watch --src where/documentation/root/is --playbook where/playbook/is.yml
```

After start the documentation can be viewed in a web browser at this URL: http://localhost:3000

Finally build can be performed by this command:
```
./sebbia-antora-builder.sh build --playbook where/playbook/is.yml --output where/to/place/html
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