variable "REPO" {
  default = "pratikimprowise/ngrok"
}

variable "VERSION" {
  default = "edge"
}

variable "ALPINE_VERSION" {
  default = "3.15"
}

variable "standard-root" {
  default = [
    "${REPO}:latest",
    "${REPO}:${VERSION}",
  ]
}

variable "standard-nonroot" {
  default = [
    "${REPO}:nonroot",
    "${REPO}:nonroot-${VERSION}",
  ]
}

variable "slim-root" {
  default = [
    "${REPO}:slim",
    "${REPO}:slim-edge",
    "${REPO}:slim-${VERSION}",
  ]
}

variable "slim-nonroot" {
  default = [
    "${REPO}:slim-nonroot",
    "${REPO}:slim-nonroot-edge",
    "${REPO}:slim-nonroot-${VERSION}",
  ]
}

variable "alpine-root" {
  default = [
    "${REPO}:alpine",
    "${REPO}:alpine-${VERSION}",
  ]
}

variable "alpine-noonroot" {
  default = [
    "${REPO}:alpine-noonroot",
    "${REPO}:alpine-noonroot-${VERSION}",
  ]
}

variable "alpine-slim-root" {
  default = [
    "${REPO}:alpine-slim",
    "${REPO}:alpine-slim-${VERSION}",
  ]
}

variable "alpine-slim-nonroot" {
  default = [
    "${REPO}:alpine-slim-nonroot",
    "${REPO}:alpine-slim-nonroot-${VERSION}",
  ]
}

target "_common" {
  args = {
    NGROK_VERSION  = VERSION
    ALPINE_VERSION = ALPINE_VERSION
  }
}

target "_labels" {
  labels = {
    "org.opencontainers.image.title"         = "ngrok",
    "org.opencontainers.image.base.name "    = "scratch",
    "org.opencontainers.image.licenses"      = "Apache-2.0",
    "org.opencontainers.image.description"   = "ngrok multiarch container image",
    "org.opencontainers.image.version"       = "${VERSION}",
    "org.opencontainers.image.revision"      = "${VERSION}",
    "org.opencontainers.image.source"        = "ngrok.com",
    "org.opencontainers.image.documentation" = "https://github.com/pratikbin/docker-ngork-multiarch",
  }
}

target "image-platforms" {
  platforms = [
    "linux/arm64",
    "linux/arm/v6",
    "linux/arm/v7",
    "linux/386",
    "linux/mips64le",
    "linux/mips64",
    "linux/ppc64le",
  ]
}

target "_standard-root" {
  target = "standard-root"
  tags   = standard-root
}

target "_standard-nonroot" {
  target = "standard-nonroot"
  tags   = standard-nonroot
}

target "_slim-root" {
  target = "slim-root"
  tags   = slim-root
}

target "_slim-nonroot" {
  target = "slim-nonroot"
  tags   = slim-nonroot
}

target "_alpine-root" {
  target = "alpine-root"
  tags   = alpine-root
}

target "_alpine-noonroot" {
  target = "alpine-noonroot"
  tags   = alpine-noonroot
}

target "_alpine-slim-root" {
  target = "alpine-slim-root"
  tags   = alpine-slim-root
}

target "_alpine-slim-nonroot" {
  target = "alpine-slim-nonroot"
  tags   = alpine-slim-nonroot
}

group "default" {
  targets = ["local"]
}

target "local" {
  inherits = ["_common", "_standard-root", "_labels"]
  output   = ["type=docker"]
}

target "local-slim" {
  inherits = ["_common", "_slim-root", "_labels"]
  output   = ["type=docker"]
}

target "_metadata" {
  inherits = ["_common", "image-platforms", "_labels"]
}

target "standard-root" {
  inherits = ["_metadata", "_standard-root"]
}

target "standard-nonroot" {
  inherits = ["_metadata", "_standard-nonroot"]
}

target "slim-root" {
  inherits = ["_metadata", "_slim-root"]
}

target "slim-nonroot" {
  inherits = ["_metadata", "_slim-nonroot"]
}

target "alpine-root" {
  inherits = ["_metadata", "_alpine-root"]
}

target "alpine-noonroot" {
  inherits = ["_metadata", "_alpine-noonroot"]
}

target "alpine-slim-root" {
  inherits = ["_metadata", "_alpine-slim-root"]
}

target "alpine-slim-nonroot" {
  inherits = ["_metadata", "_alpine-slim-nonroot"]
}
