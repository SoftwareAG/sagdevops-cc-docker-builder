# SoftwareAG Universal Messaging Docker Image with Command Central Docker Builder

This project demonstrates how to a standalone Universal Messaging (UM) docker images using Command Central Docker Builder.

## Overview

General info about "Command Central Docker Builder" can be found [HERE](../README.md)

## Configuration

1 - Login to Docker Store with your Docker ID, open https://store.docker.com/images/softwareag-commandcentral and accept license agreement to get access
to Command Central images.

Login to Docker with your Docker ID from your console and verify you can download the images:

```bash
docker login
docker pull store/softwareag/commandcentral:10.1.0.1-server
```

2 - Modify [init.yaml](init.yaml) to configure product and fix repositories, poiting to Master 10.1 repostories on Empower using your Empower credentials or point to your local 10.1 mirrors

```yaml
  product:
    products:
      location: http://sdc.softwareag.com/dataservewebM101/repository/
      username: you@company.com
      password: yourpass
  fix:
    fixes:
      location: http://sdc.softwareag.com/updates/prodRepo
      username: you@company.com
      password: yourpass
```

3 - Add your 10.1 webMethods Universal Messaging license file to the current folder as ```licenseKey.xml``` file.

## Building images

To build images using Command Central composite template run

```bash
docker-compose build
```

See [template.yaml](template.yaml) for basic webMethods Universal Messaging (UM) runtime instance definition.

There are 3 flavors of images:

* [Unmanaged](Dockerfile.unmanaged) - UM image without SPM management agent
* [Managed](Dockerfile.managed) - UM image with SPM management agent

Once built, check docker images:

```bash
docker images
```

You should see 2 new images:
 - softwareag/umserver_managed:10.1
 - softwareag/umserver:10.1

## Running containers

Start Command Central container first

```bash
docker-compose run --rm init
```

Start all 3 types of containers we just built:

```bash
docker-compose up -d
```

Wait up to 2 minutes and access them via UM Enterprise Manager:

* Unmanaged - nhp://0.0.0.0:9000
* Managed - nhp://0.0.0.0:9001

## Unmanaged image

Unmanaged image does not include management agent (SPM) and thus cannot be managed
by Command Central, but can be managed by an orchestration tool of your choice.

## Managed image

Managed image includes Command Central agent (SPM) and thus:

* You can monitor, administer and even configure it in Command Central
* And still manage by an orchestration tool of your choice

Open [Command Central](https://0.0.0.0:8091/) to see simple and managed containers in
the managed landscape.

You can run tests against them using Command Central API:

```bash
docker-compose run --rm test
```

Tail the logs if you need to

```bash
docker-compose logs -f
```

## Cleanup

```bash
docker-compose down
```

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
