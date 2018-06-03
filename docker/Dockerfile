FROM node:10.0

RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y mariadb-client

RUN groupadd -g 501 hubot && \
useradd -m -u 501 -g 501 hubot

RUN npm install -g npm \
&& npm install -g coffeescript yo \
&& adduser -h /home/hubot -D hubot
RUN rm -rf /var/cache/apk/*


COPY ["hubot/external-scripts.json", "/home/hubot/"]
COPY ["hubot/package.json", "/home/hubot/package.json"]
COPY ["hubot/scripts/", "/home/hubot/scripts/"]
COPY ["scripts/start.sh", "/home/hubot/"]

RUN chown -R hubot:hubot /home/hubot

ENV HOME /home/hubot
USER hubot
WORKDIR /home/hubot


RUN npm install generator-hubot hubot-slack
RUN echo "No" | yo hubot --adapter slack --name slackbot --defaults
RUN sed -i '/heroku/d' external-scripts.json
RUN npm install

# RUN rm hubot-scripts.json

# ENTRYPOINT ["./bin/hubot"]
CMD [ "./start.sh"]
# CMD [ "sleep", "30 &&", "./bin/hubot", "-a", "slack"]
# CMD [ "/bin/sh" ]
EXPOSE 8080
