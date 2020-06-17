#!/usr/bin/env sh
set -euf

# Start Mumble Server LDAP Auth
python3 /opt/LDAPauth/LDAPauth.py --ini /config/LDAPauth.ini --app
