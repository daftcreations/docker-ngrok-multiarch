FROM --platform=$BUILDPLATFORM docker.io/pratikimprowise/upx:3.96 AS upx
FROM --platform=$BUILDPLATFORM docker.io/library/alpine:3.15 AS builder
COPY --from=upx /usr/local/bin/upx /usr/local/bin/upx
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
    "${USER}"
ARG NGROK_VERSION="4VmDzA7iaHb"
ARG TARGETOS TARGETARCH
RUN apk --update add --no-cache curl git git ca-certificates && \
 update-ca-certificates
RUN set -x; \
  version="${NGROK_VERSION}"; \
  curl -Ls 'https://bin.equinox.io/c/'${NGROK_VERSION}'/ngrok-stable-'${TARGETOS}'-'${TARGETARCH}'.tgz' -o - | tar -xvzf - -C .; \
  upx -9 ngrok || true
RUN ./ngrok update
FROM scratch
WORKDIR /home
ENV HOME /home
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder /etc/ssl/certs/ /etc/ssl/certs/
COPY --from=builder /tmp/ngrok /usr/local/bin/ngrok
USER appuser:appuser
ENTRYPOINT ["/usr/local/bin/ngrok"]
