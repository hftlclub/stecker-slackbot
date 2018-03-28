#!/bin/bash
configfile="steckerbot.env"

if [[ -f $configfile ]]; then
  read -r -p "Eine Konfigurationsdatei existiert und wird überschrieben. Fortfahren? [y/N] " response
  case $response in
    [yY][eE][sS]|[yY])
      mv $configfile $configfile"_backup"
      ;;
    *)
      exit 1
    ;;
  esac
fi

DBNAME=db
# (A-Za-z0-9)
DBPASS=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 28)
MYSQL_ROOT_PASSWORD=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 28)

cat << EOF > $configfile
# ------------------------------
# Host
# ------------------------------
HOST_PORT=9001

# ------------------------------
# SQL DB
# ------------------------------
DBNAME=$DBNAME
DBUSER=steckerbot
DBPASS=$DBPASS

MYSQL_URL=mysql://root:$MYSQL_ROOT_PASSWORD@$DBNAME/$DBNAME
MYSQL_DATABASE=db
MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD

TZ='Europe/Berlin'

# -------------------------------
# Steckerbot Konfiguration
# -------------------------------
SB_VERSION=develop
SB_IP=0.0.0.0
SB_PORT=9001

# User configuration
SB_ADMINUSER=admin
SB_ADMINPASS=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 28)

# Fixed project name
COMPOSE_PROJECT_NAME=steckerbot-dockerized

EOF

read -r -p "Slack-Token eingeben? (y/N) " response
case $response in
    [yY][eE][sS]|[yY])
        read -r -p "Slack-Token: " slacktoken
        echo 'HUBOT_SLACK_TOKEN='$slacktoken >> $configfile
        echo "Token erfolgreich geschrieben"
        ;;
    *)
        echo "Bitte HUBOT_SLACK_TOKEN in die steckerbot.env eintragen!"
        exit 1
        ;;
esac

read -r -p "Slack-Room-ID eingeben? (y/N) " response
case $response in
    [yY][eE][sS]|[yY])
        read -r -p "Room-ID: " roomid
        echo 'ROOM_ID='$roomid >> $configfile
        echo "ID erfolgreich geschrieben"
        exit 0
        ;;
    *)
        echo "Bitte ROOM_ID in die steckerbot.env eintragen!"
        exit 1
        ;;
esac

