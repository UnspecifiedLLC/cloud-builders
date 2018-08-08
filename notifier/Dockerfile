FROM alpine

RUN apk add --update --no-cache \
    curl \
    opensmtpd \
    mini-sendmail \
    && rm -rf /var/cache/apk/* \
    && echo -e "listen on 0.0.0.0\ntable aliases file:/etc/smtpd/aliases\naccept from any for any relay" > /etc/smtpd/smtpd.conf

VOLUME /workdir
WORKDIR /workdir
COPY . /bin
