FROM golang:alpine as builder

#Snapshots 2018-01-10-23:14:45
ENV HORIZON_VERSION=6e330ca8002a030c859b7f7b8ad341ae565b444b

RUN apk add --no-cache git gcc linux-headers musl-dev glide mercurial \
    && mkdir -p /go/src/github.com/stellar/ \
    && git clone https://github.com/KinesisNetwork/go.git /go/src/github.com/stellar/go \
    && cd /go/src/github.com/stellar/go \
    && git checkout feature/ABX-4197 \
    && glide install \
    && go install github.com/stellar/go/services/horizon

FROM alpine:latest

COPY --from=builder /go/bin/horizon /usr/local/bin/horizon

EXPOSE 8000

ADD entry.sh /
ENTRYPOINT ["/entry.sh"]
CMD ["horizon"]
