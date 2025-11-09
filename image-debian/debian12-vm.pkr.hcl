packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

variable "base_iso_url" {
  type    = string
  default = "https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/debian-13.1.0-amd64-DVD-1.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:fd941eefaff97349e81f82090c0b32eef7b96518e1361666052e11f39b02711d"
}

variable "vm_name" {
  type    = string
  default = "packer-debian"
}

variable "ssh_username" {
  type    = string
  default = "debian"
}

variable "ssh_password" {
  type    = string
  default = "debian"
}

variable "packages" {
  type    = list(string)
  default = ["sudo", "apt-utils", "curl", "net-tools", "vim", "dnsutils"]
}

source "virtualbox-iso" "debian" {
  iso_url          = var.base_iso_url
  iso_checksum     = var.iso_checksum
  vm_name          = var.vm_name
  guest_os_type    = "Debian_64"
  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_wait_timeout = "30m"
  shutdown_command = "echo '${var.ssh_password}' | sudo -S shutdown -P now"
  boot_wait        = "5s"
  memory           = 2048
  cpus             = 2
  http_directory = "preseed"
  boot_command = [
  "<esc><wait>",
  "auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait><enter>"
]

}

build {
  name    = "debian-virtualbox"
  sources = ["source.virtualbox-iso.debian"]

  provisioner "shell" {
  inline = [
    # Disable CD-ROM repo
    "echo '${var.ssh_password}' | sudo -S sed -i '/^deb cdrom:/s/^/#/' /etc/apt/sources.list",

    # Add Debian repos
    "echo '${var.ssh_password}' | sudo -S wget -O /etc/apt/sources.list.d/debian.list https://gist.githubusercontent.com/hakerdefo/1599cb664cc3c2f125a45248d9c6c71d/raw/ca5d9eabe5dde45ed0bb56e44832ee24cab94ac8/sources.list",

    # Update, Upgrade, & install packages
    "echo '${var.ssh_password}' | sudo -S apt-get update",
    "echo '${var.ssh_password}' | sudo -S apt-get install -y ${join(" ", var.packages)}",
    "echo '${var.ssh_password}' | sudo -S apt-get upgrade -y",

    # Cleanup & timezone
    "echo '${var.ssh_password}' | sudo -S apt-get clean",
    "echo '${var.ssh_password}' | sudo -S rm -rf /var/lib/apt/lists/*",
    "echo '${var.ssh_password}' | sudo -S timedatectl set-timezone Asia/Tehran"
  ]
}

  provisioner "shell" {
    script = "./scripts/docker-install.sh"
  }

}
