#!/bin/sh
set -e

if [ ! -d /config/yate ]; then
  echo '******Copying configs**********'
  mv /usr/local/etc/yate /config/
else
  echo '******Removing configs**********'
  rm -rf /usr/local/etc/yate
fi

echo '******Linking configs**********'
ln -s /config/yate /usr/local/etc/yate

chown -R nobody:users /config
chmod -R 777 /config

/usr/local/bin/yate -v -Dz
