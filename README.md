# docker-ngrok-multiarch

Ngrok scratch container image

> Slim variant is availabe, compressed through [UPX](https://github.com/upx/upx).
> Original binary size ~`29MB`
> Slim varient size ~`12MB`

supported plateforms

- linux/amd64
- linux/arm64
- linux/arm/v6
- linux/arm/v7
- linux/386
- linux/mips64le
- linux/mips64
- linux/ppc64le

## Usage

```docker run --rm -it pratikimprowise/nginx http 80```

- Slim

  ```docker run --rm -it pratikbalar/nginx:slim http 80```

### Use it in Container

```Dockerfile
FROM pratikimprowise/ngork:latest AS ngrok
FROM alpine:3.15
COPY --from=ngork /usr/local/bin/ngrok /usr/local/bin/ngrok
RUN ngork --version
```

#### Slim variant

```Dockerfile
FROM pratikimprowise/ngork:slim AS ngrok
FROM alpine:3.15
COPY --from=ngork /usr/local/bin/ngrok /usr/local/bin/ngrok
RUN ngork --version
```

### Buildx

```Dockerfile
FROM --platform=$BUILDPLATFORM pratikimprowise/ngork:latest AS ngrok
FROM --platform=$BUILDPLATFORM alpine:3.15
COPY --from=ngork /usr/local/bin/ngrok /usr/local/bin/ngrok
RUN ngork --version
```

#### Slim

```Dockerfile
FROM --platform=$BUILDPLATFORM pratikimprowise/ngork:slim AS ngrok
FROM --platform=$BUILDPLATFORM alpine:3.15
COPY --from=ngork /usr/local/bin/ngrok /usr/local/bin/ngrok
RUN ngork --version
```

---

**May the Source Be With You**
