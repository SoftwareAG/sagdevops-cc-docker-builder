# Command Central Docker Builder

THIS IS NOT PUBLISHED YET !!!

This project demonstrates how to build docker images using
Command Central 10.1 Docker Builder.

## Overview

Command Central Docker Builder is an offical tool provided by Software AG
on Docker Store (link to store). It leverages Command Central templates to run
provisioning operations during Docker image build driven from a standard
Dockerfile.

## Quick Start

Requirements:

* Docker Engine 17.09.0-ce
* Software AG Empower credentials for software download center

Get project source and provide your Empower credentials
using environment variables:

```bash
git clone ...
export EMPOWER_USR=yourempoweruser@youcompany.com
export EMPOWER_PWD=yourempowerpassword
```

Below are examples of how to build different flavours of webMethods Microservices Container images.

## Building and testing simple base image

See [template.yaml] for basic webMethods Microservices Container (MSC) runtime instance definition.

```bash
export COMPOSE_PROJECT_NAME=sagdevopsccdockerbuilder
export COMPOSE_FILE=simple.yml
docker-compose build
docker images sagdevopsccdockerbuilder_simple
docker-compose up -d
```

Wait 30 seconds and open [http://localhost:5551/] and login as Administrator/manage

## Building and testing unmanaged image

IMPORTANT: build the simple image first.

Unmanaged image does not include Command Central agent (SPM) and thus cannot be managed
by Command Central, but can be managed by an orchestration tool of your choice.

```bash
export COMPOSE_FILE=unmanaged.yml
docker-compose build
docker images sagdevopsccdockerbuilder_unmanaged
docker-compose up -d
```

Wait 30 seconds and open [http://localhost:5552/] and login as Administrator/manage

## Buiding and testing managed image

IMPORTANT: build the simple image first.

Managed image includes Command Central agent (SPM) and thus:

* You can monitor, administer and even configure it in Command Central
* And still managed by an orchestration tool of your choice

Bring up Command Central first

```bash
export COMPOSE_FILE=managed.yml
docker-compose run --rm init
```

When the above command completes successfully
open [https://localhost:8091/] and login as Administrator/manage to Command Central.

Build and run managed container

```bash
docker-compose build
docker images sagdevopsccdockerbuilder_managed
docker-compose run --rm test
```

When the above command completes successfully
open [http://localhost:5553/] and login as Administrator/manage

Also check out the containter and managed runtime in Command Central.

Tail the logs if you need to

```bash
docker-compose logs -f
```

Cleanup

```bash
docker-compose down
```
