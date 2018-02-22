#!/bin/bash
configfile="steckerbot.conf"

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

cat << EOF > $configfile
# ------------------------------
# Host
# ------------------------------
HOST_PORT=9001

# ------------------------------
# SQL DB
# ------------------------------
DBNAME=steckerbot
DBUSER=steckerbot

# (A-Za-z0-9)
DBPASS=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 28)
DBROOT=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 28)

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
