FROM node:9-alpine

RUN apk update \
&& apk upgrade \
&& apk add mariadb-client \
&& npm install -g npm \ 
&& npm install -g coffeescript yo \
&& adduser -h /home/hubot -D hubot
RUN rm -rf /var/cache/apk/*

ENV HOME /home/hubot
USER hubot
WORKDIR /home/hubot

RUN npm install generator-hubot 
RUN npm install hubot-slack hubot-mysql-brain --save
RUN echo "No" | yo hubot --adapter slack --name slackbot --defaults 
RUN sed -i '/heroku/d' external-scripts.json \
&& sed -i 's/hubot-redis-brain/hubot-mysql-brain/g' external-scripts.json
# ENTRYPOINT ["./bin/hubot"]
CMD [ "./bin/hubot", "-a", "slack"]
# CMD [ "/bin/sh" ]
EXPOSE 8080
