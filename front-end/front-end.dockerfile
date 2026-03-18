# Build stage: compile the front-end binary.
FROM golang:1-alpine AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /frontEndApp ./cmd/web

# Runtime stage: copy only the compiled binary into a tiny image.
FROM alpine:latest

RUN mkdir /app
COPY --from=builder /frontEndApp /app/frontEndApp

CMD ["/app/frontEndApp"]