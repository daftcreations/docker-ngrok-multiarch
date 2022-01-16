variable "REPO" {
  default = "pratikimprowise/ngrok"
}

variable "VERSION" {
  default = "edge"
}

variable "TAGS" {
  default = [
    "${REPO}:latest",
    "${REPO}:${VERSION}",
  ]
}

variable "TAGS_SLIM" {
  default = [
    "${REPO}:slim",
    "${REPO}:edge-slim",
    "${REPO}:${VERSION}-slim",
  ]
}

target "_common" {
  args = {
    NGROK_VERSION = VERSION
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
    "org.opencontainers.image.documentation" = "https://github.com/pratikbalar/docker-ngork-multiarch",
  }
}

target "_slim" {
  target = "slim"
  tags   = TAGS_SLIM
}

target "_fat" {
  tags = TAGS
}

target "image-platform" {
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

group "default" {
  targets = ["image-local"]
}

# Creating fat container image for local docker
target "image-local" {
  inherits = ["_common", "_fat", "_labels"]
  output   = ["type=docker"]
}

# Creating slim container image for local docker
target "image-slim" {
  inherits = ["_common", "_slim", "_labels"]
  output   = ["type=docker"]
}

# Creating fat container image for all platforms
target "image-all" {
  inherits = ["_common", "image-platform", "_fat", "_labels"]
}

# Creating slim container image for all platforms
target "image-all-slim" {
  inherits = ["_common", "image-platform", "_slim", "_labels"]
}
