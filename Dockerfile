# syntax = docker/dockerfile:latest
ARG ALPINE_VERSION=3.15
FROM --platform=$BUILDPLATFORM pratikimprowise/upx:3.96 AS upx
FROM --platform=$BUILDPLATFORM gcr.io/distroless/base as certs
FROM --platform=$BUILDPLATFORM alpine:$ALPINE_VERSION AS user
RUN addgroup -S ngork -g 65432 && adduser -S ngrok -h /home/ngrok -G ngork -u 65432

FROM --platform=$BUILDPLATFORM alpine:$ALPINE_VERSION AS builder
WORKDIR /tmp
ARG TARGETOS TARGETARCH
RUN apk --update add --no-cache curl
RUN curl -Ls 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-'${TARGETOS}'-'${TARGETARCH}'.tgz' -o - | tar -xvzf - -C .

FROM builder AS slimbinary
COPY --from=upx / /
RUN upx -v --ultra-brute --best ngrok || true

FROM scratch as scratch-nonroot-base
COPY --from=builder  /etc/passwd /etc/passwd
COPY --from=builder  /etc/group  /etc/group
COPY --from=certs  /etc/ssl/certs/ /etc/ssl/certs/
USER ngork:ngork
WORKDIR /tmp
WORKDIR /home/ngrok
ENTRYPOINT ["/usr/local/bin/ngrok"]

FROM scratch as scratch-root-base
COPY --from=certs  /etc/ssl/certs/ /etc/ssl/certs/
WORKDIR /tmp
WORKDIR /
ENTRYPOINT ["/usr/local/bin/ngrok"]

FROM alpine:$ALPINE_VERSION as alpine-nonroot
RUN addgroup -S ngork -g 65432 && adduser -S ngrok -h /home/ngrok -G ngork -u 65432
USER 65432:65432
WORKDIR /tmp
WORKDIR /home/ngrok
ENTRYPOINT ["/usr/local/bin/ngrok"]

FROM alpine:$ALPINE_VERSION as alpine-root
ENTRYPOINT ["/usr/local/bin/ngrok"]

FROM scratch-root-base as standard-root
COPY --from=builder /tmp/ngrok /usr/local/bin/ngrok

FROM scratch-root-base as slim-root
COPY --from=slimbinary /tmp/ngrok /usr/local/bin/ngrok

FROM scratch-nonroot-base as standard-nonroot
COPY --from=builder /tmp/ngrok /usr/local/bin/ngrok

FROM scratch-nonroot-base as slim-nonroot
COPY --from=slimbinary /tmp/ngrok /usr/local/bin/ngrok

FROM alpine-nonroot as alpine-standard-nonroot
COPY --from=builder /tmp/ngrok /usr/local/bin/ngrok

FROM alpine-nonroot as alpine-slim-nonroot
COPY --from=slimbinary /tmp/ngrok /usr/local/bin/ngrok

FROM alpine-root as alpine-standard-root
COPY --from=builder /tmp/ngrok /usr/local/bin/ngrok

FROM alpine-root as alpine-slim-root
COPY --from=slimbinary /tmp/ngrok /usr/local/bin/ngrok
