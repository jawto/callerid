#!/bin/sh

docker run --rm --name=callerid -d -e TZ=America/Los_Angeles -p 5060:5060/udp callerid
