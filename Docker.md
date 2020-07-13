# Docker

## Dockerfile

A `Dockerfile` is a simple text file used to annotate the steps necessary to build an image. You can run the base image and go step by step installing and configuring software in the command line while completing the `Dockerfile`.

## Image

An image is usually configured on top of an existing `image` like Ubuntu or Debian.

### Basic example of a Dockefile (Not recommended)

```sh
FROM alpine:3.4

RUN apk update
RUN apk add vim
RUN apk add curl
```

Remember that different linux ditros have different package managers. `apt` for Debian and Ubuntu, `yum` for REHL and centos, etc.

This approach is **not recommended** because every Docker command generates a new intermediate image that occupies space in the hard drive as image cache. It also slows down the build process.

The **recommended approach** is to combine the commands into a single line:

```sh
FROM alpine:3.4

RUN apk update &&\ 
    apk add vim curl
```

You can still write the code in separate lines for better readibility.

Dockerfiles can be found in the Docker Hub. 

If you would like to use nginx for you next project, but there is a package which is not included in the nginx official Dockerfile, you can create a new Dockerfile using the nginx image as the base image. Notice how NGINX uses [debian](https://hub.docker.com/_/debian/) as its base image.

[NGINX](https://hub.docker.com/_/nginx/)

List Docker images:
``` sh
docker images
```

## Build an image

``` sh
docker build -t jeff/myOwnNginx:1.0 .
```
`build`: Build an image from a Dockerfile

`-t, --tag list`: Name and optionally a tag in the 'name:tag' format

In this case we also add the mantainer of the Dockerfile: mantainer/buildName:tag

The `.` refers to the current directory. Which means that I am running this command in the same directory where the Dockerfile is stored.

## Interact with image using the [CLI](https://stackoverflow.com/questions/30172605/how-do-i-get-into-a-docker-containers-shell)

```sh
docker exec -it <containerName> bash
```

`-it`: Which I like to call `interactive terminal` Basically makes the container look like a terminal connection session.

~~docker run --rm -it takacsmark/alpine-smarter:1.0 /bin/sh~~

`run`: Run a command in a new container

`--rm`: Automatically remove the container when it exits

`/bin/sh` use bash for the terminal

---
The intermidiate images created by `docker build` are called dangling images.

You can use the following command to list dangling images:

``` sh
docker images --filter "dangling=true"
```

### Remove dangling images

```sh
docker rmi $(docker images -q --filter "dangling=true")
```

`rmi`: Remove one or more images

`-f, --filter filter`: Filter output based on conditions provided`

`-q, --quiet`: Only show numeric IDs

---
## Run mysql

```sh
docker run --name mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d -p 3306:3306 mysql:8
```

## Dockerfile key instructions best practices

FROM - every Dockerfile must start with the FROM instruction in the form of `FROM <image>[:tag]`. This will set the base image for your Dockerfile, which means that subsequent instructions will be applied to this base image.

The tag value is optional, if you don’t specify the tag Docker will use the tag latest and will try and use or pull the latest version of the base image during build.

COPY vs ADD - Both `ADD` and `COPY` are designed to add directories and files to your Docker image in the form of `ADD <src>... <dest>` or `COPY <src>... <dest>`. Most resources, suggest to use COPY because it has less complexity, making it more predictable.

To pull files from the web into your image use RUN and curl and uncompress your files with RUN and commands you would use on the command line.

ENV - ENV is used to define environment variables. 

RUN - RUN has two forms; `RUN <command>` (called shell form) and `RUN ["executable", "param1", "param2"]` called exec form. Please note that `RUN <command>` will invoke a shell automatically (/bin/sh -c by default), while the exec form will not invoke a command shell.

VOLUME - You can use the `VOLUME` instruction in a Dockerfile to tell Docker that the stuff you store in that specific directory should be stored on the host file system not in the container file system. This implies that stuff stored in the volume will persist and be available also after you destroy the container.

You can inspect your volumes with the `docker volume ls` and `docker volume inspect` commands.

USER - use the USER instruction to specify the user. This user will be used to run any subsequent RUN, CMD AND ENDPOINT instructions in your Dockerfile.

WORKDIR - A very convenient way to define the working directory, it will be used with subsequent RUN, CMD, ENTRYPOINT, COPY and ADD instructions. You can specify WORKDIR multiple times in a Dockerfile.

EXPOSE - An important instruction to inform your users about the ports your application is listening on.

ONBUILD - give more flexibility to your team and clients.

Dangerous command to delete all unused images, networks, stopped containers and all build cache:

```sh
docker system prune -a
```