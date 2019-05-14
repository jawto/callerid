FROM debian:stable-slim

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    autoconf \
    curl \
    build-essential \
    libjson-perl \
    libjson-xs-perl

# Build and install Yate.
RUN mkdir /build && \
    curl -SL http://yate.null.ro/tarballs/yate6/yate-6.1.0-1.tar.gz | tar -xzC /build

WORKDIR /build/yate
RUN ./autogen.sh && \
    ./configure --prefix=/usr/local && \
    make && \
    make install-noapi && \
    echo "/usr/local/lib" >> /etc/ld.so.conf && \
    ldconfig && \
    rm -rf /build && \
    DEBIAN_FRONTEND=noninteractive apt-get purge -y autoconf build-essential && \
    DEBIAN_FRONTEND=noninteractive apt-get -y clean

# Add the callerid script
COPY scripts/caller-id.pl /usr/local/share/yate/scripts/
RUN chmod 755 /usr/local/share/yate/scripts/caller-id.pl

EXPOSE 5060/udp

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
CMD ["/entrypoint.sh"]
