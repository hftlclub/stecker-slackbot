FROM node:6.11.2-slim

ENV NPM_CONFIG_PREFIX=/home/node/steckerbot/.npm-global
ARG SB_VERSION=develop

RUN set -x; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    git \
    mariadb-client \
    bzip2 \
    && rm -rf /var/lib/apt/lists/*

USER node

#RUN git clone https://github.com/ohli/steckerbot.git --branch ${SB_VERSION} /home/node/steckerbot \
#    && mkdir /home/node/steckerbot/.npm-global

WORKDIR /home/node/steckerbot

#RUN bin/installDeps.sh \
#    && mkdir settings \
#    && mv settings.json settings/ \
#    && ln -s settings/settings.json .

#COPY modify_settings.sh /home/node/steckerbot/settings
COPY docker-entrypoint.sh /usr/local/bin/

EXPOSE 9001
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["node","node_modules/steckerbot/node/server.js"]

