# php7.1.33-fpm-nginx
This package provides a set of tools to build and run docker containers ready for php web applications. The containers are based on **Alpine Linux 3.7 + PHP 7.1.33 FPM** + **NGINX** 

## Key Features
- Suited for any php web project
- Development and production ready
- Secure, performance and size optimized docker images
- Distinct build docker receipts for each environment: develop, stage and production
- Works with [CapRover](https://www.caprover.com) out of box

## Installation

Create a new folder and clone this repository into it

```bash
mkdir project
cd project
git clone https://github.com/jeffersoncechinel/php7.1.33-fpm-nginx.git
```

Now create and empty folder called "src" and copy your web application project inside of it
```bash
mkdir src
cp -r /my/web/project/folder src/
```

Finally adjust nginx and other configurations as needed

## Usage

### For development
The develop image is optimized for productivity it uses docker volumes to share your project folder within the container eliminating re-builds on every code change.

Create and run the container based on the **develop** image
```bash
# php7.1.33-fpm-nginx/bin/run.sh develop
```

### For stage environment
Create and run the container based on the **stage** image
```bash
# php7.1.33-fpm-nginx/bin/run.sh stage
```

### For production environment
Create and run the container based on the **production** image
```bash
# php7.1.33-fpm-nginx/bin/run.sh production
```

## Advanced
By default the containers are created based on the base image hosted at [docker hub](https://hub.docker.com/repository/docker/jeffersoncechinel/php7.1.33-fpm-nginx-base). However if you prefer to build the image yourself use the build command.

```bash
# php7.1.33-fpm-nginx/bin/build.sh base|develop|stage|production
```
You can set a custom name for the final images
```bash
# php7.1.33-fpm-nginx/bin/build.sh base|develop|stage|production repository/name:tag
```
