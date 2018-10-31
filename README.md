# Command Central Docker Builder Example

This project demonstrates how to build Docker images using
Command Central Docker Builder.

## Overview

Command Central Docker Builder is a tool provided by Software AG
on [Docker Store](https://store.docker.com/images/softwareag-commandcentral).

The tool leverages Command Central [template](template.yaml) to run
provisioning operations during Docker image build, driven from a standard [Dockerfile](Dockerfile).

## Requiremements

* Docker Engine 17.05 or newer with support for [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/)

## Configuration

Login to Docker Store with your Docker ID, open [Command Central image page](https://store.docker.com/images/softwareag-commandcentral).
Proceed to Checkout and accept license agreement to get access to Command Central images.

Login to Docker with your Docker ID from your console and verify you can download the images:

```bash
docker login
docker pull store/softwareag/commandcentral-builder:10.3
```

Provide your Empower SDC credentials (email and password):

Linux or Mac:

```bash
export EMPOWER_USR=you@company.com
export EMPOWER_PSW=*****
```

Windows:

```shell
set EMPOWER_USR=you@company.com
set EMPOWER_PSW=*****
```

## Building images

To build a sample Hello World image run:

```bash
docker-compose build hello

...
Successfully tagged softwareag/hello:10.3
```

## Testing containers

Verify the image by launching the container and running a simple test:

```bash
docker-compose run --rm test

...
ID   Display Name                       Version
SPM  Infrastructure | Platform Manager  10.1.0.0.217
...
The expected values were successfully retrieved after 1 call within 44 seconds.
```

## Cleanup

```bash
docker-compose down
```

## Migrating from Command Central Docker Builder 10.1

Command Central Docker Builder 10.3 has been improved by removing limitations and adding usablity features:

1. The Command Central Builder image name has changed from `store/softareag/commandcentral:10.1-builder` to `store/softwareag/commandcentral-builder:10.3`
2. The `init.yaml` is replaced with initialization via build arguments. See [docker-compose.yml](docker-compose.yml):
   * REPO_PRODUCT_URL
   * REPO_FIX_URL
   * REPO_USERNAME
   * REPO_PASSWORD
3. The template.yaml `alias:` does not have to be `container` anymore. Can be any unique alias name.
4. The template may have required parameters (e.g. without default values). Template parameter values can be passed via:
   * [env.properties](env.properties) file located next to the `template.yaml` using param.name=value syntax
   * `ARG __param_name=value` build arguments in the [Dockerfile](Dockerfile)
5. The template must provision the layer(s) to the `${nodes}` aliases instead of `local` node alias
6. The builder now supports building images for multiple releases. See [docker-compose.yml](docker-compose.yml)

## Troubleshooting

### Running on Windows host

Your Docker build runs on Windows and fails, ensure that git client uses UNIX crlf instead of Windows.
Change git configuration and re-clone the repository

```bash
git config --global core.autocrlf false
```

_______________
Contact us at [TECHcommunity](mailto:technologycommunity@softwareag.com?subject=Github/SoftwareAG) if you have any questions.
_______________
DISCLAIMER
These tools are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG welcomes contributions, we cannot guarantee to include every contribution in the master project.
