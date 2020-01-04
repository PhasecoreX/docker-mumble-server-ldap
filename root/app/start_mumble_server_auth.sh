#!/bin/bash
set -e

# Start Mumble Server LDAP Auth
python3 /opt/LDAPauth/LDAPauth.py --ini /config/LDAPauth.ini --app

