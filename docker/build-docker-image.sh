#!/bin/bash

if [ -z "$1" ]; then
  echo "Verwendung: $0 example.com"
  exit 1
else
  DOMAIN="$1"
fi

IMAGE="steckerbot"

cd $(dirname $0)

docker images | grep $DOMAIN
if [ $? ]; then
  echo -e -n "\n### [ 1. ] docker image $IMAGE existiert, wird nicht überschrieben"
  echo -e -n "\n### [INFO] Führe 'docker rmi $IMAGE' zuerst aus, wenn ein neues Image erstellt werden soll"
fi

echo -e -n "\n### [ 2. ] Setup des Datenverzeichnisses ..."
  mkdir -p ./data/steckerbot
  cp -r ../../dist/node_modules ./data/steckerbot/
  cp ../../dist/*js ./data/steckerbot/

echo -e -n "\n### [ 4. ] Erstelle docker Image (bitte warten) ..."
  docker build -t $IMAGE .
  docker images | grep $DOMAIN
if [ $? ]; then
  echo -e -n "\n### [ 4. ] ... fertig, docker Image $IMAGE wurde erstellt"
else
  echo -e -n "\n### [ 4. ] ... es ist etwas schief gelaufen"
  exit 1;
fi

echo -e -n "\n### [ 5. ] erstelle Konfiguration für Domäse: $DOMAIN ...\n\n"
REALPATHEXISTS=$(realpath . 2>/dev/null)
if [[ "$REALPATHEXISTS""n" == "n" ]]; then
  realpath ()
  {
	f=$@;
	if [ -d "$f" ]; then
	base="";
	dir="$f";
	else
	base="/$(basename "$f")";
	dir=$(dirname "$f");
	fi;
	dir=$(cd "$dir" && /bin/pwd);
	echo -e -n "$dir$base"
  }
fi

  DATA=$(realpath ./data)
  docker run -v $DATA:/data --rm -e SERVER_NAME=$DOMAIN $IMAGE generate

echo -e -n "\n### [ 6. ] ... fertig"
echo -e -n "\n### [ 7. ] start.sh and stop.sh kann verwendet werden, um den Container zu sarten oder zu beenden"
