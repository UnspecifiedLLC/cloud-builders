FROM node:alpine

RUN apk add --update --no-cache \
    autoconf \
    automake \
    bash \
    cairo-dev \
    g++ \
    git \
    giflib-dev \
    libjpeg-turbo-dev \
    libtool \
    make \
    python \
    && npm install -g mocha

ENTRYPOINT [ "npm" ]
CMD [ "install-test" ]