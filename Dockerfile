FROM gliderlabs/alpine:3.3

# Setup Golang environments.
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH   $PATH:$GOROOT/bin:$GOPATH/bin
ENV GO15VENDOREXPERIMENT 1

# Install APK packages.
RUN echo "System dependencies" && \
    apk add --update curl make rsyslog git musl go bash nodejs vim && \
    echo "Build dependencies" && \
    apk add gcc g++ && \
    echo "Install yarn" && \
    npm install -g yarn && \
    echo "App dependencies" && \
    apk add --update libsodium libsodium-dev && \
    echo "Goofys dependencies" && \
    apk add --update fuse fuse-dev && \
    echo "Supervisor dependencies" && \
    apk add --update python py-pip && \
    pip install --upgrade pip && \
    pip install supervisor && \
    mkdir -p /var/log/supervisor && \
    echo "AWS CLI dependencies" && \
    pip install awscli && \
    mkdir -p /root/.aws && \
    rm -rf /var/cache/apk/*

# Install HAProxy
RUN echo "HAProxy dependencies" && \
    apk add --no-cache --virtual .build-deps \
        gcc g++ linux-headers python pcre pcre-dev openssl-dev zlib zlib-dev libssl1.0 libcrypto1.0 busybox && \
    echo "HAProxy install" && \
    cd /tmp && \
    wget -q http://www.haproxy.org/download/1.6/src/haproxy-1.6.4.tar.gz && \
    tar -xzf haproxy-*.tar.gz && \
    cd haproxy-* && \
    make PREFIX=/usr TARGET=linux2628 USE_PCRE=1 USE_PCRE_JIT=1 USE_OPENSSL=1 USE_ZLIB=1 && \
    make PREFIX=/usr install-bin && \
    mkdir -p /etc/haproxy && \
    mkdir -p /var/log/haproxy && \
    rm -Rf /tmp/* && \
    apk del .build-deps && \
    apk add pcre
