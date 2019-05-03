#!/bin/sh
set -e

if [ ! -d /config/yate ]; then
  echo '******MOVING**********'
  mv /usr/local/etc/yate /config/

  echo '******LINKING**********'
  ln -s /config/yate /usr/local/etc/yate

  chown -R nobody:users /config
  chmod -R 777 /config
fi

/usr/local/bin/yate -v -Dz
