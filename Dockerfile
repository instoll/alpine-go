FROM gliderlabs/alpine:3.6

# Setup Golang environments.
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH   $PATH:$GOROOT/bin:$GOPATH/bin

# Install APK packages.
RUN echo "System dependencies" && \
    apk add --update curl make git musl go bash vim && \
    echo "Install NPM" && \
    apk add nodejs nodejs-npm && \
    npm install npm@latest -g && \
    echo "Install yarn" && \
    npm install -g yarn && \
    # echo "Build dependencies" && \
    # apk add gcc g++ && \
    echo "Supervisor dependencies" && \
    apk add --update python py-pip && \
    pip install --upgrade pip && \
    pip install supervisor && \
    mkdir -p /var/log/supervisor && \
    echo "AWS CLI dependencies" && \
    pip install awscli && \
    mkdir -p /root/.aws && \
    rm -rf /var/cache/apk/*
