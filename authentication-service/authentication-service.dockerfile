# build a tiny docker image
# executable image
FROM alpine:latest

RUN mkdir /app

COPY cmd/bin/authApp /app

CMD ["app/authApp"]