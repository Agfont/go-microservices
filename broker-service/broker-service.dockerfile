# build a tiny docker image
# executable image
FROM alpine:latest

RUN mkdir /app

COPY cmd/bin/brokerApp /app

CMD ["app/brokerApp"]