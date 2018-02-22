#!/bin/bash

settingspath=/home/node/steckerbot/settings/

file1=($(sha1sum /home/node/steckerbot/settings/settings.json))
file2=($(sha1sum /home/node/steckerbot/settings.json.template))
if [[ "$file1" != "$file2" ]]
then
  echo "Settings already modified"
  exit 0;
fi

#replace connection values with environment
# IP
line=$(grep -n \"ip\" "$settingspath"settings.json -A$(wc -l "$settingspath"settings.json)|grep \"0.0.0.0\" |grep -o '[[:digit:]]*'|head -1)
if [[ $line ]]
then
  sed -i "${line}s/\(:\s*\"\).*\(\"\)/\1$EP_IP\2/g" "$settingspath"settings.json
fi

# PORT
line=$(grep -n \"port\" "$settingspath"settings.json -A$(wc -l "$settingspath"settings.json)|grep 9002 | grep -o '[[:digit:]]*'|head -1)
if [[ $line ]]
then
  sed -i "${line}s/\(:\s\)\(.*[[:digit:]]\)/\1$EP_PORT/g" "$settingspath"settings.json
fi

#comment out dirty option for db
line=$(grep -n \"dbType\" "$settingspath"settings.json |grep dirty|grep -o '[[:digit:]]*')
if [[ $line ]]
then
  sed -i "${line}s/^/  \/\//g" "$settingspath"settings.json
fi

#replace database config values with environment
line=$(grep -n \"dbSettings\" "$settingspath"settings.json -A$(wc -l "$settingspath"settings.json)|grep \"user\" |grep -o '[[:digit:]]*'|head -1)
if [[ $line ]]
then
  sed -i "${line}s/\(:\s*\"\).*\(\"\)/\1$DBUSER\2/g" "$settingspath"settings.json
fi

line=$(grep -n \"dbSettings\" "$settingspath"settings.json -A$(wc -l "$settingspath"settings.json)|grep \"host\" |grep -o '[[:digit:]]*'|head -1)
if [[ $line ]]
then
  sed -i "${line}s/\(:\s*\"\).*\(\"\)/\1$MYSQL_DB_HOST\2/g" "$settingspath"settings.json
fi

line=$(grep -n \"dbSettings\" "$settingspath"settings.json -A$(wc -l "$settingspath"settings.json)|grep \"host\" |grep -o '[[:digit:]]*'|head -1)
if [[ $line ]]
then
  sed -i "${line}s/\(:\s*\"\).*\(\"\)/\1$MYSQL_DB_HOST\2/g" "$settingspath"settings.json
fi

line=$(grep -n \"dbSettings\" "$settingspath"settings.json -A$(wc -l "$settingspath"settings.json)|grep \"password\" |grep -o '[[:digit:]]*'|head -1)
if [[ $line ]]
then
  sed -i "${line}s/\(:\s*\"\).*\(\"\)/\1$DBPASS\2/g" "$settingspath"settings.json
fi

line=$(grep -n \"dbSettings\" "$settingspath"settings.json -A$(wc -l "$settingspath"settings.json)|grep \"database\" |grep -o '[[:digit:]]*'|head -1)
if [[ $line ]]
then
  sed -i "${line}s/\(:\s*\"\).*\(\"\)/\1$DBNAME\2/g" "$settingspath"settings.json
fi

echo "Settings modified"

