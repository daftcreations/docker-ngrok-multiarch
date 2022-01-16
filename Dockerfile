# syntax = docker/dockerfile:1.3

FROM --platform=$BUILDPLATFORM pratikimprowise/upx:3.96 AS upx
FROM --platform=$BUILDPLATFORM alpine:3.15 AS base
SHELL ["/bin/sh","-cex"]
WORKDIR /tmp
# Create appuser.
ENV USER=appuser
ENV UID=1001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"ex

FROM base AS builder
ARG TARGETOS TARGETARCH
RUN apk --update add --no-cache curl git ca-certificates && \
 update-ca-certificates
RUN curl -Ls 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-'${TARGETOS}'-'${TARGETARCH}'.tgz' -o - | tar -xvzf - -C .

FROM builder AS bin-slim
COPY --from=upx / /
RUN upx -v --ultra-brute --best ngrok || true

FROM scratch as slim
COPY --from=builder  /etc/passwd /etc/passwd
COPY --from=builder  /etc/group  /etc/group
COPY --from=builder  /etc/ssl/certs/ /etc/ssl/certs/
COPY --from=bin-slim /tmp/ngrok /usr/local/bin/ngrok
USER appuser:appuser
WORKDIR /home
ENV HOME /home
ENTRYPOINT ["/usr/local/bin/ngrok"]

# RUN ./ngrok update
FROM scratch
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder /etc/ssl/certs/ /etc/ssl/certs/
COPY --from=builder /tmp/ngrok /usr/local/bin/ngrok
USER appuser:appuser
WORKDIR /home
ENV HOME /home
ENTRYPOINT ["/usr/local/bin/ngrok"]
