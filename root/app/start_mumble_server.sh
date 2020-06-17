#!/usr/bin/env sh
set -euf

# Set database location
sed -i '/database=/c\database=/data/mumble-server.sqlite' /config/mumble-server.ini

# Start Mumble Server
/usr/sbin/murmurd -fg -ini /config/mumble-server.ini
