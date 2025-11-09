# Packer Templates

Automated image builders for Debian-based systems using Packer.

## Contents

- **docker-debian.pkr.hcl** - Builds customized Debian Docker images
- **virtualbox-debian.pkr.hcl** - Builds Debian VirtualBox VMs **with Docker pre-installed**

## Prerequisites

- [Packer](https://www.packer.io/downloads) >= 1.8.0
- Docker (for Docker builds) or VirtualBox (for VM builds)
- Docker Hub account (for pushing images)

## Quick Start

```bash
# Initialize and build
packer init <template>.pkr.hcl
packer validate <template>.pkr.hcl
packer build <template>.pkr.hcl
```

## Docker Builder

Builds a Debian Bookworm image with essential tools (curl, vim, net-tools, sudo).

**Key Variables:**
- `tag` - Image version (default: `1.0.0`)
- `registry_repo` - Docker registry (default: `ali9k/packer-debian`)
- `packages` - Package list to install

**Example:**
```bash
packer build -var="tag=2.0.0" -var='packages=["curl","vim","git"]' docker-debian.pkr.hcl
```

## VirtualBox Builder

Builds a Debian 13.1.0 VM with 2 CPUs and 2GB RAM, including Docker and other packages, using automated installation.

**Key Variables:**
- `vm_name` - VM name (default: `packer-debian`)
- `ssh_username/ssh_password` - SSH credentials (default: `debian/debian`)
- `packages` - Package list to install

**Required Files:**
- `preseed/preseed.cfg` - Automated installation config
- `scripts/docker-install.sh` - Docker installation script

**Example:**
```bash
packer build -var="vm_name=my-vm" virtualbox-debian.pkr.hcl
```

## Configuration

Both templates use:
- Timezone: Asia/Tehran
- Maintainer: ali99kalbasi82@gmail.com
- Base: Debian Bookworm/13.1.0

Customize by passing variables with `-var` flag or creating a `variables.pkrvars.hcl` file.