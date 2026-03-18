# build a tiny docker image
# executable image
FROM alpine:latest

RUN mkdir /app

COPY cmd/bin/mailApp /app
COPY templates /templates

CMD ["app/mailApp"]