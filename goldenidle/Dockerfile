FROM golang:1.16 AS builder

ARG GOPROXY=direct
ENV GOPROXY=$GOPROXY

ADD . /app

RUN cd /app && go mod download

RUN cd /app && go build -o /bin/goldenidle

FROM bitnami/kubectl:1.19

COPY --from=builder /bin/goldenidle /bin/goldenidle

ENTRYPOINT ["/bin/goldenidle"]
