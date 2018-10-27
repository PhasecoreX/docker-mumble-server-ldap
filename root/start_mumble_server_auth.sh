#!/bin/bash
set -e

# Start Mumble Server LDAP Auth
/usr/bin/python2.7 /opt/LDAPauth/LDAPauth.py --ini /config/LDAPauth.ini --app

