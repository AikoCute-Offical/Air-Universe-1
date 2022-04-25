# Build go
FROM golang:1.16-alpine AS builder
WORKDIR /app
COPY . .
ENV CGO_ENABLED=0
RUN go mod download
RUN go build -v -o au -trimpath -ldflags "-s -w -buildid=" ./cmd/Air-Universe

# Release
FROM  alpine
RUN  apk --update --no-cache add tzdata ca-certificates \
    && cp /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
RUN mkdir /etc/au/ && mkdir -p /usr/local/share/au/
COPY --from=builder /app/au /usr/local/bin
ENTRYPOINT [ "au", "-c", "/etc/au/config.json"]
