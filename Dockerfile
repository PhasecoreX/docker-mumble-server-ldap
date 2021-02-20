FROM phasecorex/user-ubuntu:focal

RUN set -eux; \
    \
    buildDeps='gnupg2'; \
    apt-get update; \
    apt-get install -y --no-install-recommends $buildDeps; \
    apt-key adv --keyserver keyserver.ubuntu.com --recv 85DECED27F05CF9E; \
    apt-get purge -y --auto-remove $buildDeps; \
    \
    echo "deb http://ppa.launchpad.net/mumble/release/ubuntu focal main" >> /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        # https://bugs.launchpad.net/ubuntu/+source/mumble/+bug/1782980
        libssl-dev \
        mumble-server \
        python3-ldap \
        python3-zeroc-ice \
        supervisor \
        zeroc-ice-compilers \
    ; \
    # clean up
    rm -rf /var/lib/apt/lists/*

COPY root/ /

VOLUME ["/data", "/config"]
EXPOSE 64738

CMD ["supervisord"]

LABEL maintainer="Ryan Foster <phasecorex@gmail.com>"
