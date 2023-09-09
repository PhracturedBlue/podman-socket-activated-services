FROM golang:alpine as builder

ENV CGO_ENABLED=0
WORKDIR /src
RUN --mount=type=bind,target=/src,rw \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=target=/go/pkg/mod,type=cache \
      set -x ; go build -o /usr/bin/kopia

FROM alpine
RUN apk --no-cache add ca-certificates rclone tzdata fuse3 curl

ENV \
                    TERM="xterm-256color" \
                    LC_ALL="C.UTF-8" \
                    KOPIA_CONFIG_PATH=/app/config/repository.config \
                    KOPIA_LOG_DIR=/app/logs \
                    KOPIA_CACHE_DIRECTORY=/app/cache \
                    RCLONE_CONFIG=/app/rclone/rclone.conf \
                    KOPIA_PERSIST_CREDENTIALS_ON_CONNECT=false \
                    KOPIA_CHECK_FOR_UPDATES=false

WORKDIR /app

COPY --from=builder /usr/bin/kopia /usr/bin/kopia

ENTRYPOINT      ["/usr/bin/kopia"]
