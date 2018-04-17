FROM golang:alpine as builder

#Snapshots 2018-01-10-23:14:45
ENV HORIZON_VERSION=a8d9398f87675215ba03f2e76f5f509db51712e8

RUN apk add --no-cache git gcc linux-headers musl-dev glide mercurial \
    && mkdir -p /go/src/github.com/stellar/ \
    && git clone https://github.com/KinesisNetwork/go.git /go/src/github.com/stellar/go \
    && cd /go/src/github.com/stellar/go \
    && git checkout $HORIZON_VERSION \
    && glide install \
    && go install github.com/stellar/go/services/horizon

FROM alpine:latest

COPY --from=builder /go/bin/horizon /usr/local/bin/horizon

EXPOSE 8000

ADD entry.sh /
ENTRYPOINT ["/entry.sh"]
CMD ["horizon"]
