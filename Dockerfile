FROM debian:buster-slim

RUN useradd -u 1000 -m -U webdriver

WORKDIR /home/webdriver

COPY chromium-installer /home/webdriver/chromium-installer

ARG CHROMIUM_REVISION
ENV CHROMIUM_REVISION=${CHROMIUM_REVISION}

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install --no-install-recommends --no-install-suggests -y \
    ca-certificates \
    curl \
  && /home/webdriver/chromium-installer ${CHROMIUM_REVISION:-0} /home/webdriver true \
  && ln -s /home/webdriver/chrome-linux/chrome /usr/local/bin/chrome \
  && mv /home/webdriver/chromedriver_linux64/chromedriver /usr/local/bin/ \
  && apt-get autoremove --purge -y \
      unzip \
      gnupg \
  && apt-get clean \
  && rm -rf \
    /usr/share/doc/* \
    /var/cache/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /home/webdriver/*.zip

USER webdriver

ENTRYPOINT ["chromedriver"]

CMD ["--port=4444", "--whitelisted-ips="]

EXPOSE 4444
