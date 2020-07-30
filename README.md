# BCO App

[![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![](https://img.shields.io/docker/cloud/build/sevenbridges/bco-app.svg)](https://hub.docker.com/r/sevenbridges/bco-app/builds)
[![](https://images.microbadger.com/badges/version/sevenbridges/bco-app.svg)](https://microbadger.com/images/sevenbridges/bco-app)
[![](https://img.shields.io/docker/pulls/sevenbridges/bco-app.svg)](https://hub.docker.com/r/sevenbridges/bco-app)
[![DOI](https://zenodo.org/badge/218053074.svg)](https://zenodo.org/badge/latestdoi/218053074)

The BCO App is a Shiny app to create, validate, and browse [BioCompute Objects](https://biocomputeobject.org/).

![](https://sbg.github.io/bco-app/assets/landing.png)

## Overview

This repo offers the source code for the app's Docker image, including the Dockerfile and the app built by the Seven Bridges team. The app features BioCompute Object (BCO) creation (manually or by importing from CWL workflows), BCO checksum/schema validators, PDF report generator, and an interactive BCO browser.

This `README` gives a brief introduction to pull the Docker image and run the app locally. For detailed usage of the app and more deployment options, please check our [PDF user manual](https://sbg.github.io/bco-app/bco-app-user-manual.pdf).

## Installation

First of all, please make sure that Docker is installed in your system, and the `docker` commands are available from the terminal. If not, here is the [official installation guide](https://docs.docker.com/install/).

### Pull or build the image

To pull the pre-built Docker image from its [Docker Hub repo](https://hub.docker.com/r/sevenbridges/bco-app), use:

```bash
docker pull sevenbridges/bco-app
```

Alternatively, you can choose to build the image, which could take a few minutes:

```bash
git clone https://github.com/sbg/bco-app.git
cd bco-app
docker build . -t bco-app
```

### Run the container

If the image was pulled from Docker Hub, use

```bash
docker run --rm -p 3838:3838 --name sb sevenbridges/bco-app
```

If the image was built locally, use

```bash
docker run --rm -p 3838:3838 --name sb bco-app
```

### Open the app

After the container is running, open http://127.0.0.1:3838 in your web browser.

(If required, use the credential `sevenbridges`/`sevenbridges` to log in.)

### Clean up the container and image

```bash
docker rm -f sb
docker rmi sevenbridges/bco-app
```

or

```bash
docker rm -f sb
docker rmi bco-app
```

## Additional Resources

- [biocompute: Create and Manipulate BioCompute Objects](https://cran.r-project.org/package=biocompute)
- [tidycwl: Tidy Common Workflow Language Tools and Workflows](https://cran.r-project.org/package=tidycwl)

## Copyright

© 2020 Seven Bridges Genomics, Inc. All rights reserved.

This project is licensed under the [GNU Affero General Public License v3](LICENSE).
