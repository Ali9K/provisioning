# Vagrant Multi-VM Environment (Debian 13)

This project creates a lightweight virtual lab using **Vagrant** and **VirtualBox**, featuring two **Debian 13** virtual machines.  
Each VM is automatically provisioned with either **Docker** or **Ansible** for development and testing purposes.

---

## Overview

- **Base Image:** `bento/debian-13.1`
- **VMs Created:**
  - `vm1_1` → installs Docker via `install-docker.sh`
  - `vm2_1` → installs Ansible via `install-ansible.sh`
- **Private Network IPs:**
  - `vm1_1`: `192.168.56.101`
  - `vm2_1`: `192.168.56.201`
- **Resources per VM:**
  - 2 GB RAM
  - 1 CPU core
- **Parallel Startup:** Disabled (`VAGRANT_NO_PARALLEL = yes`)

You can scale the number of nodes by adjusting the following in `Vagrantfile`:
```ruby
FIRST_NODE = 1
SECOND_NODE = 1
```

---

## Setup Instructions

- 1. Clone the Repository

    `git clone <your-repo-url>`
    `cd <repo-directory>`

- 2. Add the Debian 13 Box

    `vagrant init bento/debian-13.1 --box-version 202510.26.0`

- 3. Start and Provision the VMs

    `vagrant up --provision`

Once the setup completes, you can connect to your VMs using:

    `vagrant ssh vm1_1`
    `vagrant ssh vm2_1`

---

## Cleanup

To destroy all created virtual machines:

    `vagrant destroy -f`

---

## Requirements

- Vagrant

- VirtualBox

- Provisioning scripts:

    `install-docker.sh`

    `install-ansible.sh`