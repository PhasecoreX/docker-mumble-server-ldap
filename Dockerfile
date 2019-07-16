FROM phasecorex/user-python:2.7-slim

RUN set -eux; \
    \
    buildDeps=' \
        dirmngr \
        gnupg2 \
        software-properties-common \
    '; \
    apt-get update; \
    apt-get install -y --no-install-recommends $buildDeps; \
    \
    apt-key adv --batch --keyserver keyserver.ubuntu.com --recv B6391CB2CFBA643D; \
    apt-add-repository "deb http://zeroc.com/download/Ice/3.7/debian9 stable main"; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        # https://bugs.launchpad.net/ubuntu/+source/mumble/+bug/1782980
        libssl-dev \
        mumble-server \
        supervisor \
        python-zeroc-ice \
        python-ldap \
        zeroc-ice-slice \
    ; \
    # clean up
    apt-get purge -y --auto-remove $buildDeps; \
    rm -rf /var/lib/apt/lists/*

COPY root/ /

VOLUME ["/data", "/config"]
EXPOSE 64738

CMD ["supervisord"]

LABEL maintainer="Ryan Foster <phasecorex@gmail.com>"
