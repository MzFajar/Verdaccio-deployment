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

## Step 5: run config.yaml and htpasswd

open CI CD on repository verdaccio but we must request access to the master first

![adduser](/readme-img/03.png)

run updated from jobs one by one

> ⚠️ have access from brench master

and make sure everything runs without errors

![adduser](/readme-img/04.png)

now the user that has been added can already be used