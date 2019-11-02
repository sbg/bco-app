# Genomics Compliance Suite by Seven Bridges <a href="https://www.sevenbridges.com"><img src="https://raw.githubusercontent.com/sbg/gcs/master/logo.png" align="right" alt="logo" height="128" width="128" /></a>

[![](https://img.shields.io/docker/cloud/build/sevenbridges/gcs.svg)](https://hub.docker.com/r/sevenbridges/gcs/builds)
[![](https://img.shields.io/docker/pulls/sevenbridges/gcs.svg)](https://hub.docker.com/r/sevenbridges/gcs)
[![](https://images.microbadger.com/badges/image/sevenbridges/gcs.svg)](https://microbadger.com/images/sevenbridges/gcs)

Genomics Compliance Suite (GCS) is a Shiny app built by Seven Bridges to create, validate, and browse [BioCompute Objects](https://biocomputeobject.org/).

The repo offers the source code for the app's Docker image, including the Dockerfile and the app built by the Seven Bridges team. The app features BioCompute Object (BCO) creation (manually or by importing from CWL workflows), BCO checksum/schema validators, PDF report generator, and an interactive BCO browser.

This `README` file gives a brief introduction to pull the Docker image and run the app locally. For detailed usage of the app and more deployment options, please check our [PDF user manual](https://github.com/sbg/gcs/blob/master/sevenbridges-gcs-user-manual.pdf).

## How to run the app locally

First of all, please make sure that Docker is installed in your system, and the `docker` commands are available from the terminal. If not, here is the [official installation guide](https://docs.docker.com/install/).

### Pull or build the image

To pull the pre-built Docker image from its [Docker Hub repo](https://cloud.docker.com/repository/docker/sevenbridges/gcs), use:

```bash
docker pull sevenbridges/gcs
```

Alternatively, you can choose to build the image, which could take a few minutes:

```bash
git clone https://github.com/sbg/gcs.git
cd gcs
docker build . -t gcs
```

### Run the container

If the image was pulled from Docker Hub, use

```bash
docker run --rm -p 3838:3838 --name sb sevenbridges/gcs
```

If the image was built locally, use

```bash
docker run --rm -p 3838:3838 --name sb gcs
```

### Log into the app

After the container is running

- Open `http://127.0.0.1:3838` in your web browser.
- Use the username/password `sevenbridges`/`sevenbridges` to log in.

### Clean up the container and image after running

```bash
docker rm -f sb
docker rmi sevenbridges/gcs
```

or

```bash
docker rm -f sb
docker rmi gcs
```

## Links

[PrecisionFDA BioCompute Object App-a-thon Challenge](https://precision.fda.gov/challenges/7/view)

## Copyright

© 2019 Seven Bridges Genomics, Inc. All rights reserved.

This project is licensed under the [GNU Affero General Public License v3](LICENSE).
