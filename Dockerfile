FROM lsiobase/alpine:3.9

RUN apk add --no-cache \
    autoconf \
    build-base \
    curl \
    libstdc++ \
    perl-json \
    perl-libwww \
    tar

RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    perl-json-xs

RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main \
    patch

# Build and install Yate.
RUN mkdir /build && \
    curl -SL http://yate.null.ro/tarballs/yate6/yate-6.1.0-1.tar.gz | tar -xzC /build

# Apply patches to enable compiling on Alpine.
WORKDIR /build/yate
COPY patches/* /build/
RUN patch Makefile.in < /build/Makefile.in.patch
RUN patch engine/Mutex.cpp < /build/Mutex.cpp.patch
RUN patch yateclass.h < /build/yateclass.h.patch

RUN ./autogen.sh && ./configure --prefix=/usr/local
RUN make && make install

RUN rm -rf /build
RUN apk del --purge autoconf build-base curl tar patch

# Add the callerid script
COPY scripts/caller-id.pl /usr/local/share/yate/scripts/
RUN chmod 755 /usr/local/share/yate/scripts/caller-id.pl

EXPOSE 5060/udp

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
CMD ["/entrypoint.sh"]
