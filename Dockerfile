FROM golang:1.20 AS builder

ARG VERSION
ARG GOPROXY
WORKDIR /workspace
COPY cmd/ cmd/
COPY pkg/ pkg/
COPY go.mod go.mod
COPY go.sum go.sum
COPY main.go main.go
COPY README.md README.md

RUN GOPROXY=${GOPROXY} go mod download
RUN GOPROXY=${GOPROXY} CGO_ENABLED=0 go build -ldflags "-w -s" -o atest-store-mongodb .

FROM alpine:3.12

LABEL org.opencontainers.image.source=https://github.com/LinuxSuRen/atest-ext-store-mongodb
LABEL org.opencontainers.image.description="MongoDB Store Extension of the API Testing."

COPY --from=builder /workspace/atest-store-mongodb /usr/local/bin/atest-store-mongodb

CMD [ "atest-store-mongodb" ]
