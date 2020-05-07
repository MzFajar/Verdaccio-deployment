# Verdaccio NPM Server

[Verdaccio](https://verdaccio.org/) is a simple, **zero-config-required local private npm registry**.
No need for an entire database just to get started! Verdaccio comes out of the box with
**its own tiny database**, and the ability to proxy other registries (eg. npmjs.org),
caching the downloaded modules along the way.
For those looking to extend their storage capabilities, Verdaccio
**supports various community-made plugins to hook into services such as Amazon's s3,
Google Cloud Storage** or create your own plugin.

## Install

Install with npm:

```bash
npm install --global verdaccio
```
> ⚠️ After v4.5.0 Node v8 is not longer supported. **Node v10** is the minimum supported version.

Install with Docker:

```bash
docker pull verdaccio/verdaccio:tags
```

> ⚠️ tags is a **tags** of verdaccio

## Step 1: Git clone verdaccio Agate

![verdaccio repository](/readme-img/00.png)

Clone with HTTP:

```
git clone http://gategit.agate.id/devops/verdaccio-deployment.git
```

## Step 2: Update config.yaml

**config.yaml** is the file where we do the configuration for verdaccio, config.yaml:
```
#
# This is the config file used for the docker images.
# It allows all users to do anything, so don't use it on production systems.
#
# Do not configure host and port under `listen` in this file
# as it will be ignored when using docker.
# see https://verdaccio.org/docs/en/docker#docker-and-custom-port-configuration
#
# Look here for more config file examples:
# https://github.com/verdaccio/verdaccio/tree/master/conf
#

# path to a directory with all packages
storage: /verdaccio/storage
# path to a directory with plugins to include
plugins: /verdaccio/plugins

web:
  # WebUI is enabled as default, if you want disable it, just uncomment this line
  enable: true
  title: Agate Verdaccio
  logo: /verdaccio/web/logo.png
  primary_color: "#00A1E4"
  # scope: "@scope"
  darkMode: false
  # comment out to disable gravatar support
  # gravatar: false
  # by default packages are ordercer ascendant (asc|desc)
  sort_packages: asc

auth:
  htpasswd:
    file: /verdaccio/conf/htpasswd
    # Maximum amount of users allowed to register, defaults to "+infinity".
    # You can set this to -1 to disable registration.
    max_users: -1

# a list of other known repositories we can talk to
uplinks:
  npmjs:
    url: https://registry.npmjs.org/

packages:
  '@agate*':
    # scoped packages
    access: $authenticated
    publish: $authenticated
    unpublish: $authenticated
    proxy: npmjs

  '**':
    # allow all users (including non-authenticated users) to read and
    # publish all packages
    #
    # you can specify usernames/groupnames (depending on your auth plugin)
    # and three keywords: "$all", "$anonymous", "$authenticated"
    access: $authenticated

    # allow all known users to publish/publish packages
    # (anyone can register by default, remember?)
    publish: $authenticated
    unpublish: $authenticated

    # if package is not available locally, proxy requests to 'npmjs' registry
    proxy: npmjs

server:
  keepAliveTimeout: 60

middlewares:
  audit:
    enabled: true

# log settings
logs:
  - { 
      type: stdout, 
      format: pretty, 
      level: http
    }
  - { 
      type: file, 
      path: /verdaccio/log/info.log, 
      level: info,
      options: {period: 1d}
    }
  - {
      type: file, 
      path: /verdaccio/log/warn.log, 
      level: warn,
      options: {period: 1d}
    }
  - {
      type: file, 
      path: /verdaccio/log/error.log, 
      level: error,
      options: {period: 7d}
    }
  - {
      type: file, 
      path: /verdaccio/log/fatal.log, 
      level: fatal,
      options: {period: 1d}
    }

security:
  api:
    legacy: true
    web:
      sign:
        expiresIn: 7d
      verify:
         someProp: [value]

#experiments:
#  # support for npm token command
#  token: false

# This affect the web and api (not developed yet)
#i18n:
#web: en-US
```

## Step 3: Adduser

to be able add users we have to add them manually to the **htpasswd**.
and to create a user we use the htpasswd generator on the https://hostingcanada.org/htpasswd-generator/

![htpasswd generator](/readme-img/01.png)

then copy the generat results to **htpasswd**

![adduser](/readme-img/02.png)

## Step 4: Git push config.yaml and htpasswd

push **config.yaml** and **htpasswd** were updated to git reposiroty

```
git add .
git commit -m "update conf htpasswd"
```

>  " " is comment for commit

```
git push origin develop
```

> ⚠️ **develop** is a branch

## Step 5: create marge request

to be able to merge what we have pushed we must first make a merge request

## Step 6: run config.yaml and htpasswd

open CI CD on repository verdaccio but we must create merge request from develop to master branch first

![job](/readme-img/03.png)

run updated from jobs one by one

> ⚠️ have access from brench master

and make sure everything runs without errors

![run job](/readme-img/04.png)

now the user that has been added can already be used

## Step 7 : login to Agate Verdaccio

Open Agate Verdaccio on your browser in http://172.16.0.18, but you have to use **vpn agate** to be able to access

![Agate verdaccio](/readme-img/05.png)

Now login with your user account to open or see the package

![login verdaccio](/readme-img/06.png)

## Step 8 : Publish the Package with CLI

To publish your package you must **login** first, **login**:

```
npm login --registry http://172.16.0.18
```

Now you can **publish** your package, **publish**:

```
npm publish <packagename> --registry http://172.16.0.18
```

![publish](/readme-img/07.png)

> ⚠️ if the folder name and package name are different then the folder name is published but the name of the package is set up or the package that is in it

![publish](/readme-img/08.png)

## Step 9 : Install your Package

You can **install** the package by using another package that has not been published or another folder that you want to **install** the package, **install**:

```
npm install <packagename> --registry http://172.16.0.18
```

![install](/readme-img/09.png)

## Step 10 : Delete or Unpublish package

You can also delete or **unpublish** your package, **unpublish**:

```
npm unpublish <packagename> --force --registry http://172.16.0.18
```

![unpublish](/readme-img/10.png)