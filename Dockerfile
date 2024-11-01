FROM debian:bullseye-slim

RUN useradd -u 1000 -m -U webdriver

WORKDIR /home/webdriver

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install --no-install-recommends --no-install-suggests -y \
    ca-certificates \
    curl \
    netcat \
    chromium-driver chromium \
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

RUN ln -s /usr/bin/chromium /usr/local/bin/chrome

USER webdriver

ENTRYPOINT ["chromedriver"]

CMD ["--port=4444", "--whitelisted-ips=", "--allowed-origins=*"]

EXPOSE 4444
