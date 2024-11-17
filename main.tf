terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

resource "proxmox_vm_qemu" "node" {

  count = 1

  name        = "node01.k8s.local"
  desc        = "node01"
  target_node = "pve01"

  cores   = 2
  sockets = 1
  memory  = 4096

  os_type   = "cloud-init"
  ipconfig0 = "ip=10.0.0.10${count.index + 1}/24,gw=10.0.0.1"
  # ipconfig0 = dhcp

  disks {
    ide {
      ide0 {
        cdrom {
         iso = "local:iso/Rocky-9.4-x86_64-minimal.iso"
        }
      }
    }
    sata {
      sata0 {
        disk {
          size = 10
          storage = "proxmox-share-lvm"
        }
      }
    }
  }


#   ssh_user        = "root"
#   ssh_private_key = <<EOF
# -----BEGIN RSA PRIVATE KEY-----
# private ssh key root
# -----END RSA PRIVATE KEY-----
# EOF

#   os_type   = "cloud-init"
#   ipconfig0 = "ip=10.0.2.99/16,gw=10.0.2.2"

#   sshkeys = <<EOF
# ssh-rsa AABB3NzaC1kj...key1
# ssh-rsa AABB3NzaC1kj...key2
# EOF

  # provisioner "remote-exec" {
  #   inline = [
  #     "ip a"
  #   ]
  # }
}