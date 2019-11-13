# Mumble Server LDAP
A Mumble Server container with support for an LDAP back-end

[![Docker Pulls](https://img.shields.io/docker/pulls/phasecorex/mumble-server-ldap)](https://hub.docker.com/r/phasecorex/mumble-server-ldap)
[![Image Size](https://images.microbadger.com/badges/image/phasecorex/mumble-server-ldap.svg)](https://microbadger.com/images/phasecorex/mumble-server-ldap)
[![Build Status](https://img.shields.io/docker/build/phasecorex/mumble-server-ldap)](https://hub.docker.com/r/phasecorex/mumble-server-ldap)
[![Donate to support my code](https://img.shields.io/badge/Paypal-Donate-blue.svg)](https://paypal.me/pcx)

## Some Initial Thoughts
Mumble is great, except for the fact that a Mumble server by default is wide open to the internet, allowing anyone to join and waste your bandwidth. There are things called authenticators that check a users name and password against some sort of a back-end database. This image combines the Mumble server with an LDAP authenticator.

I realize that there's literally dozens of people out there that self-host an LDAP server managing users, so this image may not be right for you. There are plenty of simple Mumble server images out there. This is not one of them.

## Configuration
You really want to run this, huh? Okay. There's some setup to it though.
1. First, you're going to want to copy the two files out of `/root/config` and edit them to your liking.
	1. `mumble-server.ini` will need the `icesecretwrite=` set, for use in the authenticator config.
	2. `LDAPauth.ini` needs a slew of things set.
		1. `secret` will be the `icesecretwrite=` you set in `mumble-server.ini` 
		2. `ldap_uri`'s IP address will need to be the container name if running against an LDAP server container, e.g. `ldap://openldap`
		3. Having a `readonly` user in your LDAP server will probably save you some headaches.
		4. Fill in all that other stuff. Good luck.
	3. Don't worry about log paths in either config, they're going to be written to the `/data` volume.
2. Install an LDAP server.
	1. Yeah, not going to go into details on this one, because no one is actually going to be reading this.
	2. Let me know if you need help though, and I'll try to help out.
	3. I used `osixia/openldap` and `osixia/phpldapadmin` as my server and front-end, respectively.

## Help Configuring LDAP
My goodness, I am such a nice person (take that with a grain of salt; I haven't actually tested this). Modify and import this LDIF into your LDAP server to create the necessary stuff. It adds:
1. Entry 1: readonly user `cn=readonly,dc=example,dc=com` with password `readonly`
2. Entry 4-5: example user `uid=username,ou=users,dc=example,dc=com` with password `readonly`
3. Entry 2-3: Mumble group `cn=mumble,ou=groups,dc=example,dc=com` with example user as it's only member

You'll want to modify `dc=example,dc=com` throughout the document to reflect whatever you're using. Once you import it, you can go and look at how the data is laid out, and modify it to your liking (for example, don't leave an example user with a default password in there!)
```
# LDIF Export for dc=example,dc=com
# Server: openldap (openldap)
# Search Scope: sub
# Search Filter: (objectClass=*)
# Total Entries: 8
#
# Generated by phpLDAPadmin (http://phpldapadmin.sourceforge.net) on October 27, 2018 4:38 pm
# Version: 1.2.3

version: 1

# Entry 1: cn=readonly,dc=example,dc=com
dn: cn=readonly,dc=example,dc=com
cn: readonly
description: LDAP read only user
objectclass: simpleSecurityObject
objectclass: organizationalRole
userpassword: {SSHA}R2OQaUpaUQNafw28LU1u3wwrCZ6QOBXk

# Entry 2: ou=groups,dc=example,dc=com
dn: ou=groups,dc=example,dc=com
objectclass: organizationalUnit
objectclass: top
ou: groups

# Entry 3: cn=mumble,ou=groups,dc=example,dc=com
dn: cn=mumble,ou=groups,dc=example,dc=com
cn: mumble
objectclass: groupOfUniqueNames
objectclass: top
uniquemember: uid=username,ou=users,dc=example,dc=com

# Entry 4: ou=users,dc=example,dc=com
dn: ou=users,dc=example,dc=com
objectclass: organizationalUnit
objectclass: top
ou: users

# Entry 5: uid=username,ou=users,dc=example,dc=com
dn: uid=username,ou=users,dc=example,dc=com
cn: FirstName
displayname: Username
objectclass: inetOrgPerson
objectclass: top
roomnumber: 1
sn: LastName
uid: username
userpassword: {SSHA}R2OQaUpaUQNafw28LU1u3wwrCZ6QOBXk
```

If you need even more help, check the authenticator itself at `/root/opt/LDAPauth/LDAPauth.py`. It has a nice LDAP layout and helpful hints.

## How to Run
Simply run it like so:
```
docker run -p 64738:64738 -v /local/folder/for/config/files:/config -v /local/folder/for/persistence:/data -e TZ=America/Detroit -e PUID=1000 phasecorex/mumble-server-ldap
```
- `-p 64738:64738`: Mumble server port
- `-v /local/folder/for/config/files:/config`: Folder where you kept those two config files you modified.
- `-v /local/folder/for/persistence:/data`: Folder to persist data.
- `-e TZ=America/Detroit`: Specify a timezone.
- `-e PUID=1000`: Specify the user this server will run as. All files it creates will be owned by this user on the host.
- `-e PGID=1000`: Can also be specified if you want a specific group. If not specified, the PGID will be used as the group.

You will have to somehow link this container to your LDAP server. That can either be by linking the containers, adding this to a docker-compose file, or running this Mumble server as a host container and hitting a locally installed LDAP server.

## Final Thoughts
This image works for me, and that's all that really matters here. I can't really make the image easier to use, simply because LDAP is an unwieldy beast. If you need help setting anything up, I'll try to help out. Maybe if someone else goes through this pain of setting up an LDAP server, we can update this documentation to make it easier for others.

