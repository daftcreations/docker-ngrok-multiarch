# docker-ngrok-multiarch

Ngrok container image

Available in 8 varients
  - Scratch
  - Scratch slim
  - Scratch nonroot (ngork:ngork)
  - Scratch slim nonroot (ngork:ngork)
  - Alpine
  - Alpine slim
  - Alpine nonroot (ngork:ngork)
  - Alpine slim nonroot (ngork:ngork)

supported plateforms
  - Linux (`amd64`, `arm64`, `arm/v6`, `arm/v7`, `386`, `mips64le`, `mips64`, `ppc64le`)

## Usage

```shell
docker run --rm -it --name ngork pratikbin/ngork http 80
```

## Development

Install emulators

```shell
docker buildx create --name multiarch --use
docker run --privileged --rm tonistiigi/binfmt --install all
```

```shell
git clone --depth 1 https://github.com/pratikbin/docker-ngrok-multiarch.git docker-ngrok-multiarch
cd docker-ngrok-multiarch

## Build local image
docker buildx bake
```

---

*May the Source Be With You*
