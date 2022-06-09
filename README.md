# Chromedriver Chromium

This is a [Dockerfile](https://docs.docker.com/engine/reference/builder/) to
create a [Webdriver](https://www.w3.org/TR/webdriver/) image with
[ChromeDriver](https://chromedriver.chromium.org/) and
[Chromium](https://www.chromium.org/) out-of-box.

## Usage

### General
The `spryker/chromedriver` image is public and available on Docker Hub. You can use this
repository to run and install Chromedriver with appropriate version of Chromium within:
- [Docker](#docker)
- [Composer (PHP)](#composer)
- [Travis CI](#travis)

#### Docker
The `spryker/chromedriver` is available on Docker Hub. starts a Chromedriver server on port `4444`
by default. In its turn, Chromedriver wraps Webdriver to run tests within `Chromium` ecosystem.

The very basic [docker-compose](https://docs.docker.com/compose/compose-file/)
configuration that is sufficient to use Chromium and Chromedriver within your ecosystem is next:

```yml
version: "3.7"
services:
  chromedriver:
    image: spryker/chromedriver
    init: true
    environment:
      - CHROMIUM_VERSION=726767
    volumes:
      - ./assets:/home/webdriver/assets:ro
    expose:
      - "4444"
```

You can control the revision of Chromium (and Chromedriver as well) with just putting
`CHROMIUM_REVISION` environment variable into docker-compose template (as mentioned above).

#### Composer
To install Chromedriver with Chromium onboard, you just need to run
```shell script
composer require --dev "spryker/docker-chromedriver"
```
and modify `composer.json` file to make all necessary installation actions:
```json
{
  "scripts": {
    "post-install-cmd": [
      "ChromedriverInstaller\\Installer::installChromedriver"
    ],
    "post-update-cmd": [
      "ChromedriverInstaller\\Installer::installChromedriver"
    ]
  }
}
```
This will lead to install of the `latest` nightly build of Chromedriver and Chromium.

To freeze version of Chromedriver you can take on any [revision number](https://commondatastorage.googleapis.com/chromium-browser-snapshots/index.html?prefix=Linux_x64/) and mention it
within `composer.json` configuration (just ensure your revision contains both Chromedriver and Chromium archives):
```json
{
  "config": {
    "chromium-revision": 814168
  }
}
```

Next time you will run Composer install/update, script will check whether
the revision has changed and/or differs from latest/fixed one. If so, it will install the actual version of
Chromedriver. Nothing will happen in else case. This is to reduce Composer worktime.

##### Skip installation
To ignore Chromedriver installation process just set the appropriate variable berfore running Composer:
```shell script
export COMPOSER_IGNORE_CHROMEDRIVER=1
```
This will force skipping installation procedure during Composer run.

#### Travis CI
To use this package within Travis image you just need to use `chromium-installer` to prepare Chromium and Chromedriver for run.

First of all, you need to specify cache directory:

```yml
cache:
  directories:
    - $HOME/chromium-ecosystem
```

Then download and unzip installer:

```yml
before_install:
  # Chromedriver section
  - curl -L "https://github.com/spryker/docker-chromedriver/archive/master.zip" -o $HOME/chromium-ecosystem/chromiumdriver.zip
  - unzip -o $HOME/chromium-ecosystem/chromiumdriver.zip -d $HOME/chromium-ecosystem/
  # Here you can leave 0 for installing latest nightly build
  - export CHROMEDRIVER_REVISION=814168
```

And finally run installer:

```yml
  # Exposes ${CHROMEDRIVER_BINARY} and ${CHROMIUM_BINARY}
  - . $HOME/chromium-ecosystem/chromiumdriver-master/chromium-installer $CHROMEDRIVER_REVISION $HOME/chromium-ecosystem false
```

And finally, ensure you have added all dependencies, needed to run `Chromium`:

```yml
addons:
  apt:
    update: true
    packages:
      - unzip
      - gnupg
      - libnss3-dev
      - ca-certificates
      - fonts-liberation
      - libappindicator3-1
      - libasound2
      - libatk-bridge2.0-0
      - libatk1.0-0
      - libc6
      - libcairo2
      - libcups2
      - libdbus-1-3
      - libexpat1
      - libfontconfig1
      - libgbm1
      - libgcc1
      - libglib2.0-0
      - libgtk-3-0
      - libnspr4
      - libnss3
      - libpango-1.0-0
      - libpangocairo-1.0-0
      - libstdc++6
      - libx11-6
      - libx11-xcb1
      - libxcb1
      - libxcomposite1
      - libxcursor1
      - libxdamage1
      - libxext6
      - libxfixes3
      - libxi6
      - libxrandr2
      - libxrender1
      - libxss1
      - libxtst6
      - lsb-release
      - wget
      - xdg-utils
```

That's it! Now you can just run `Chromedriver` and pass right `Chromium` executable into Webdriver config:

```yml
script:
- bash -c "${CHROMEDRIVER_BINARY} --port=4444 --whitelisted-ips= --url-base=/wd/hub --log-path=/tmp/chromedriver.log --log-level=DEBUG" > /dev/null &
``` 

## Dependencies
To run Chromedriver with Chromium you need to install this list of dependencies beforehand:
```shell script
apt-get update \
&& apt-get install gnupg \
      libnss3-dev \
      ca-certificates \
      fonts-liberation \
      libappindicator3-1 \
      libasound2 \
      libatk-bridge2.0-0 \
      libatk1.0-0 \
      libc6 \
      libcairo2 \
      libcups2 \
      libdbus-1-3 \
      libexpat1 \
      libfontconfig1 \
      libgbm1 \
      libgcc1 \
      libglib2.0-0 \
      libgtk-3-0 \
      libnspr4 \
      libnss3 \
      libpango-1.0-0 \
      libpangocairo-1.0-0 \
      libstdc++6 \
      libx11-6 \
      libx11-xcb1 \
      libxcb1 \
      libxcomposite1 \
      libxcursor1 \
      libxdamage1 \
      libxext6 \
      libxfixes3 \
      libxi6 \
      libxrandr2 \
      libxrender1 \
      libxss1 \
      libxtst6 \
      lsb-release \
      wget \
      xdg-utils
```

## Software
The following software is included in this image:
- [ChromeDriver](https://chromedriver.chromium.org/) (latest)
- [The Chromium Project](https://www.chromium.org/) (latest)

## Pay attention

Since this package relies on nightly builds, not all versions of Chromium are available to download.
To check the available revisions, please visit
[Google Chromium Snapshots](https://commondatastorage.googleapis.com/chromium-browser-snapshots/index.html?prefix=Linux_x64/)
archive and find appropriate snapshot revision.
