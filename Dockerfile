FROM phasecorex/user-python:2.7-slim

MAINTAINER Ryan Foster <phasecorex@gmail.com>

RUN set -ex; \
    \
    buildDeps=' \
        dirmngr \
        gnupg2 \
        software-properties-common \
        
    '; \
    apt-get update; \
    apt-get install -y --no-install-recommends $buildDeps; \
    \
    apt-key adv --keyserver keyserver.ubuntu.com --recv B6391CB2CFBA643D; \
    apt-add-repository "deb http://zeroc.com/download/Ice/3.7/debian9 stable main"; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        # https://bugs.launchpad.net/ubuntu/+source/mumble/+bug/1782980
        libssl1.0-dev \
        mumble-server \
        supervisor \
        python-zeroc-ice \
        python-ldap \
        zeroc-ice-slice \
    ; \
    # clean up
    apt-get purge -y --auto-remove $fetchDeps; \
    rm -rf /var/lib/apt/lists/*

COPY root/ /

VOLUME ["/data", "/config"]
EXPOSE 64738

CMD ["/usr/bin/supervisord"]