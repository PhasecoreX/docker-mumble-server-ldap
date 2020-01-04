FROM phasecorex/user-debian:10-slim

RUN set -eux; \
    \
    # pip used for supervisor/setuptools install only
    buildDeps=' \
        gnupg2 \
        python3-pip \
    '; \
    apt-get update; \
    apt-get install -y --no-install-recommends $buildDeps; \
    apt-key adv --keyserver keyserver.ubuntu.com --recv B6391CB2CFBA643D; \
    \
    echo "deb http://zeroc.com/download/ice/3.7/debian10 stable main" >> /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        # https://bugs.launchpad.net/ubuntu/+source/mumble/+bug/1782980
        libssl-dev \
        mumble-server \
        python3-ldap \
        python3-zeroc-ice \
        zeroc-ice-compilers \
    ; \
    pip3 install --no-cache-dir setuptools supervisor; \
    # clean up
    apt-get purge -y --auto-remove $buildDeps; \
    rm -rf /var/lib/apt/lists/*

COPY root/ /

VOLUME ["/data", "/config"]
EXPOSE 64738

CMD ["supervisord"]

LABEL maintainer="Ryan Foster <phasecorex@gmail.com>"
