FROM alpine

RUN apk add --update --no-cache gettext
COPY . /bin

ENTRYPOINT [ "entrypoint.sh" ]