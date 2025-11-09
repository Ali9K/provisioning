packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

variable "base_image" {
  type    = string
  default = "debian:bookworm"
}

variable "image_name" {
  type    = string
  default = "packer-debian"
}

variable "maintainer" {
  type    = string
  default = "ali99kalbasi82@gmail.com"
}

variable "packages" {
  type    = list(string)
  default = ["curl", "vim", "net-tools", "sudo"]
}

variable "registry_repo" {
  type    = string
  default = "ali9k/packer-debian"
}

variable "tag" {
  type    = string
  default = "1.0.0"
}

source "docker" "debian" {
  image  = var.base_image
  commit = true
  changes = [
    "LABEL maintainer=${var.maintainer}",
    "ENV DEBIAN_FRONTEND=noninteractive",
    "ENV TZ=Asia/Tehran"
  ]
}

build {
  name    = "debian-docker"
  sources = ["source.docker.debian"]

  # Install base packages
  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install -y apt-utils",
      "apt-get install -y ${join(" ", var.packages)}",
      "apt-get clean",
      "rm -rf /var/lib/apt/lists/*"
    ]
  }

  # Tag final image
  post-processor "docker-tag" {
    repository = var.image_name
    tag        = [var.tag]
  }

  # Push to Docker Hub or registry
  post-processor "docker-push" {
    name = "${var.registry_repo}:${var.tag}"
  }
}
