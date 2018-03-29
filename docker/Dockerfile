FROM node:6.13

RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y mariadb-client

RUN groupadd -g 501 hubot && \
useradd -m -u 501 -g 501 hubot

COPY ["hubot/external-scripts.json", "hubot/package.json", "/home/hubot/"]
COPY ["hubot/node_modules/", "/home/hubot/node_modules/"]
COPY ["hubot/scripts/", "/home/hubot/scripts/"]

RUN npm install -g npm \
&& npm install -g coffeescript yo \
&& adduser -h /home/hubot -D hubot
RUN rm -rf /var/cache/apk/*

RUN chown -R hubot:hubot /home/hubot

ENV HOME /home/hubot
USER hubot
WORKDIR /home/hubot



RUN npm install generator-hubot hubot-slack
RUN echo "No" | yo hubot --adapter slack --name slackbot --defaults
RUN sed -i '/heroku/d' external-scripts.json

# RUN rm hubot-scripts.json

# ENTRYPOINT ["./bin/hubot"]
CMD [ "./bin/hubot", "-a", "slack"]
# CMD [ "/bin/sh" ]
EXPOSE 8080
