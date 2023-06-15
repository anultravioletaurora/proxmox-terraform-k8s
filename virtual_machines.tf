resource "proxmox_virtual_environment_vm" "k3s_cp_01" {
  name        = "${var.machine_name}-01"
  description = "Managed by Terraform"
  tags        = ["terraform"]
  node_name   = var.proxmox_node

  cpu {
    cores = var.cp_cores
  }

  memory {
    dedicated = var.cp_memory
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
    mac_address = "AA:BB:57:FA:6A:DF"
    vlan_id = 88
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_file.debian_cloud_image.id
    interface    = "scsi0"
    size         = var.cp_disk_size
  }

  serial_device {} # The Debian cloud image expects a serial port to be present

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    
    datastore_id      = "local-lvm"
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
    
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
  
  provisioner "local-exec" {
    command = <<EOT
            k3sup install \
            --ip $IP_ADDRESS \
            --cluster \
            --context k3s \
            --ssh-key ~/.ssh/id_rsa \
            --user ${var.username} \
            --k3s-version ${var.k3s_version}
        EOT

    environment = {
      IP_ADDRESS = "${self.ipv4_addresses[1][0]}"
    }
  }
}

resource "proxmox_virtual_environment_vm" "k3s_cp_02" {
  name        = "${var.machine_name}-02"
  description = "Managed by Terraform"
  tags        = ["terraform"]
  node_name   = var.proxmox_node

  cpu {
    cores = var.cp_cores
  }

  memory {
    dedicated = var.cp_memory
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
    mac_address = "BE:C7:6E:0E:40:C1"
    vlan_id = 88
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_file.debian_cloud_image.id
    interface    = "scsi0"
    size         = var.cp_disk_size
  }

  serial_device {} # The Debian cloud image expects a serial port to be present

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    
    datastore_id      = "local-lvm"
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
    
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
  
  provisioner "local-exec" {
    command = <<EOT
            k3sup install \
            --ip $IP_ADDRESS \
            --server \
            --server-ip ${proxmox_virtual_environment_vm.k3s_cp_01.ipv4_addresses[1][0]} \
            --context k3s \
            --ssh-key ~/.ssh/id_rsa \
            --user ${var.username} \
            --k3s-version ${var.k3s_version}
        EOT

    environment = {
      IP_ADDRESS = self.ipv4_addresses[1][0]
    }
  }
}

resource "proxmox_virtual_environment_vm" "k3s_workers" {
  
  # Number of workers to create, defined in variables.tf
  count       = var.worker_count
  
  name        = "${var.machine_name}-worker-0${count.index + 1}"
  description = "Managed by Terraform"
  tags        = ["terraform"]
  node_name   = var.proxmox_node

  cpu {
    cores = var.worker_cores
  }

  memory {
    dedicated = var.worker_memory
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
    mac_address = "62:7B:20:3C:B3:53"
    vlan_id = 88
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_file.debian_cloud_image.id
    interface    = "scsi0"
    size         = var.worker_disk_size
  }

  serial_device {} # The Debian cloud image expects a serial port to be present

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    
    datastore_id      = "local-lvm"
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
  
  provisioner "local-exec" {
    command = <<EOT
            k3sup join \
            --ip $IP_ADDRESS \
            --server-ip ${proxmox_virtual_environment_vm.k3s_cp_01.ipv4_addresses[1][0]} \
            --ssh-key ~/.ssh/id_rsa \
            --user var.username \
            --k3s-version ${var.k3s_version}
        EOT

    environment = {
      IP_ADDRESS = self.ipv4_addresses[1][0]
    }
  }
}
