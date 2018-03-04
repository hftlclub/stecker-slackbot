FROM node:9-alpine

RUN apk update \
&& apk upgrade \
&& apk add mariadb-client \
&& npm install -g npm \ 
&& npm install -g coffeescript yo \
&& npm install generator-hubot hubot-slack \ 
&& adduser -h /home/hubot -D hubot
RUN rm -rf /var/cache/apk/*

ENV HOME /home/hubot
USER hubot
WORKDIR /home/hubot

RUN echo "No" | yo hubot --adapter slack --name slackbot --defaults \
&& sed -i '/heroku/d' external-scripts.json
ENTRYPOINT ["/bin/sh"]
