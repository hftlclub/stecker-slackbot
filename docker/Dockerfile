FROM FROM nodesource/node:6.3.0

ADD ../src/package.json .
RUN npm install
ADD ../src src

COPY init-steckerbot.sh /init-steckerbot.sh
RUN chmod +x /init-steckerbot.sh
ENTRYPOINT ["/init-steckerbot.sh"]

EXPOSE 1337
CMD ["npm", "run", "startForever"]
VOLUME ["/data"]
