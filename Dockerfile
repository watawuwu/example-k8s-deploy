FROM golang:1.9.4-alpine3.7

WORKDIR /go/src
COPY main.go .
RUN go build -o app

CMD ["./app"]
