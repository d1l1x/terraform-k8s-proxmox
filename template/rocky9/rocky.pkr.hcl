packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}


variable "username" {
  type = string
}

variable "token" {
  type = string
}

variable "http_interface" {
  type = string
}

source "proxmox-iso" "rocky" {
  proxmox_url = "https://10.0.0.5:8006/api2/json"
  insecure_skip_tls_verify = true
  node = "pve01"
  username = var.username
  token = var.token

  cpu_type = "host"
  memory = 2048

  boot_iso {
      type = "scsi"
      iso_file = "local:iso/Rocky-9.4-x86_64-minimal.iso"
      unmount = true
      iso_checksum = "sha256:ee3ac97fdffab58652421941599902012179c37535aece76824673105169c4a2"
  }
  unmount_iso          = true
  template_name = "rocky-9-cloud-init"
  template_description = "Rocky using cloud-init, created ${timestamp()}"

  ssh_username = "root"
  ssh_password = "foobar"
  ssh_timeout  = "180m"

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }

  http_directory = "http"
  http_interface = var.http_interface

  # boot_command = [
  #   "<up><wait><tab><end><wait> inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>"
  # ]
  boot_command = [
    "<up><tab>",
    " ip=dhcp",
    " inst.cmdline",
    " inst.ks=http://{{.HTTPIP}}:{{.HTTPPort}}/ks.cfg",
    "<enter>"
  ]

  disks {
    disk_size         = "32G"
    format            = "raw"
    storage_pool      = "proxmox-share-lvm"
    type              = "scsi"
  }
}

build {
  sources = ["source.proxmox-iso.rocky"]
}
