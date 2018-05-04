# Command Central Docker Builder

This project demonstrates how to build Docker images using
Command Central Docker Builder.

## Overview

Command Central Docker Builder is an tool provided by Software AG
on [Docker Store](https://store.docker.com/images/softwareag-commandcentral). It leverages Command Central templates to run
provisioning operations during Docker image build, driven from a standard Dockerfile.

## Configuration

Login to Docker Store with your Docker ID, open https://store.docker.com/images/softwareag-commandcentral and accept license agreement to get access
to Command Central images.

Login to Docker with your Docker ID from your console and verify you can download the images:

```bash
docker login
docker pull store/softwareag/commandcentral:10.1-server
```

Copy init-10.1.yaml into init.yaml file and update it
with your Empower credentials (email and password):

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

For CI you can use the following method:

```bash
export RELEASE=10.1
export EMPOWER_USERNAME=you@company.com
export EMPOWER_PASSWORD=youpass
envsubst < init-$RELEASE.yaml > init.yaml
```

## Building images

To build simple image using Command Central composite template run:

```bash
docker-compose build simple

...
Successfully tagged managed/msc:10.1
```

It may take up to 20 minutes to download the binaries and build the image.

While it is building, check out [template.yaml](template.yaml) that is used for building
this image with basic webMethods Microservices Container (MSC) runtime instance definition.

There are 3 flavors of images:

* [Simple](Dockerfile.simple) - easy way to build images
* [Unmanaged](Dockerfile.unmanaged) - customized image without SPM management agent
* [Managed](Dockerfile.managed) - customized image with SPM management agent

Build the unmanaged and managed images by running:

```bash
docker-compose build unmanaged managed
...
Successfully tagged managed/msc:10.1
```

Check image sizes:

```bash
docker images | grep msc

managed/msc     10.1    195596d9c020        Less than a second ago   1.56GB
unmanaged/msc   10.1    3009317db4a8        Less than a second ago   1.52GB
simple/msc      10.1    cfe3a4674b31        6 minutes ago            2.5GB
```

### Simple image

There is no size optimization for this image but it is the easiest to build.
Suitable for ad-hoc testing.

Simple image comes with SPM and thus can be managed in Command Central.

### Unmanaged image

Unmanaged image does not include management agent (SPM) and thus cannot be managed
by Command Central, but can be managed by an orchestration tool of your choice.

### Managed image

Managed image includes Command Central agent (SPM) and thus:

* You can monitor, administer and even configure it in Command Central
* And still manage by an orchestration tool of your choice
* The cost is a small overhead in terms of image size (~40mb) and a second process within the container

## Running containers

Let's run containers from the images we just built.

### License key

If you want the containers to run for more than 30 minutes, provide a valid Software AG license key:

* Copy 10.x webMethods Microservices Container or Integration Server license key file to the current folder and name it ```licenseKey.xml```.
* Uncomment volume mappings for the license key file in the [docker-compose.yml](docker-compose.xml):

```yaml
    volumes:
      - ./licenseKey.xml:/opt/softwareag/IntegrationServer/instances/default/config/licenseKey.xml
```

If you don't have your license key file handy, just skip this step.

### Running unmanaged containers

Start unmanaged container by running this command:

```bash
docker-compose up -d unmanaged

...
sagdevops-cc-docker-builder_cc_1 is up-to-date
Creating sagdevops-cc-docker-builder_unmanaged_1 ... done
```

Wait until container comes up.
You can monitor the log using this command until you see ONLINE statement like this:

```bash
docker-compose logs -f unmanaged

...
unmanaged_1  | Integration Server is ONLINE at ...
```

Stop tailing the log by pressing Ctrl+C.

Open Integration Server Admin UI at [http://0.0.0.0:5552/](http://0.0.0.0:5552/)
and login as Administrator/manage.

Congratuations!

This is your custom-built webMethods Microservices Runtime container v10.1 with the latest core fixes
and basic configuration applied built from a simple Command Central YAML template!

### Running managed containers

We can take advantage of the management capabilities privided by Command Central not just at the image
build time, but at container runtime as well.

Start Command Central container first:

```bash
docker-compose run --rm init
...
Alias   Name    Status  Url Host        Url Port        Location Id     Installation Type
local   Local   ONLINE  localhost           8092
The expected values were successfully retrieved after 13 calls within 181 seconds.
```

Wait until the command completes.

Open [Command Central](https://0.0.0.0:8091/) and login as Administrator/manage.

> NOTE that Command Central image comes from Docker Store. We did not build or customize it anyhow.

Click on the Installations tab and notice that the list of managed installations includes only 'local' node.

Start managed container by running:

```bash
docker-compose up -d managed
docker-compose logs -f managed

...
managed_1    | Registering '...' with Command Central server 'cc' ...
managed_1    | 200 OK

managed_1    | 2018-05-04 17:04:55 UTC [ISP.0046.0012I] Enabling HTTP Listener on port 5555
...
managed_1    | Integration Server is ONLINE at http://9eef625c9410:5555/
```

Stop tailing the log by pressing Ctrl+C.

Open Integration Server Admin UI at [http://0.0.0.0:5553/](http://0.0.0.0:5553/)
and login as Administrator/manage.

Open Command Central Web UI Installations and Instances tabs and notice
this Integration Server runtime instance is automatialy discovered and registred
within Command Central managed landscape.

Within Command Central Web UI you can:

* View Integration Server container runtime status and monitoring KPIs
* View and dowload logs
* Administer triggers
* View configuration

Using Command Central API and CLI:

* You can run simple smoke tests to verify successful setup. See 'test' container command in docker-compose.yml for details.

```bash
docker-compose run --rm test
```

Congratulations!

You can now build managed and unmanaged Docker images for Software AG products using
Command Central Docker Builder and composite templates.

## Cleanup

```bash
docker-compose down
```

## Adapting templates to work with Command Central Docker Builder 10.1

> Command Central Docker Builder 10.1 has the following requirements for the template.yaml:

* The template alias MUST be *container*, e.g. `alias: container`
* The template MUST use repositories named *products* and *fixes* to match those defined in `init.yaml` file
* There MUST be no required parameters in the template. All parameters MUST have default values
* The template MUST provision the layer(s) to the `local` node alias

See the difference between [adopted template.yaml](template.yaml) and [original template.yaml](https://github.com/SoftwareAG/sagdevops-templates/blob/master/templates/sag-msc-server/template.yaml) for MSC basic template.

> The above limitations will be removed removed in the upcoming releases of Command Central Builder 10.2 to allow seamless use of the same templates for VMs and containers

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
