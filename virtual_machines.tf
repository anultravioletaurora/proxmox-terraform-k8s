data "proxmox_virtual_environment_nodes" "available_nodes" {}

resource "proxmox_virtual_environment_vm" "k3s_cp_01" {
  name        = "${var.cluster_name}-01"
  description = "Control plane server in the ${var.cluster_name} k3s cluster and managed by Terraform. Created on ${formatdate("MMM DD, YYYY")} at ${formatdate("H:mm:ss AA")}"
  tags        = ["k3s", "terraform"]
  node_name   = proxmox_virtual_environment_nodes.available_nodes[0]

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
}

# Run a provisioner locally after the first CP node has been created
# This will create the cluster and allow the other nodes to join it
resource "null_resource" "k3sup_cp_01_provisioner" {

  provisioner "local-exec" {
    command = "k3sup install --ip=${proxmox_virtual_environment_vm.k3s_cp_01.network_interface.0.ip_address} --user=${var.username} --ssh-key=~/.ssh/id_rsa"
  }

  # We can only execute this after the cp finishes getting built
  depends_on = [
    proxmox_virtual_environment_vm.k3s_cp_01,
  ]
}

resource "proxmox_virtual_environment_vm" "k3s_cp_02" {

  # Number of additional control plane servers to create - enabling HA
  # Defined in variables.tf
  count       = var.additional_control_plane_count



  name        = "${var.cluster_name}-0${count.index + 1}" # TODO: Make this pad the number automatically
  description = "Additional control plane server in the ${var.cluster_name} k3s cluster and managed by Terraform. Created on ${formatdate("MMM DD, YYYY")} at ${formatdate("H:mm:ss AA")}"
  tags        = ["k3s", "terraform"]

  # Balances the machines across all nodes
  node_name   = proxmox_virtual_environment_nodes.available_nodes[(count - 1) % length(proxmox_virtual_environment_nodes.available_nodes) + count.index]

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
}

resource "proxmox_virtual_environment_vm" "k3s_workers" {
  
  # Number of workers to create
  # Defined in variables.tf
  count       = var.worker_count
  
  name        = "${var.cluster_name}-worker-0${count.index + 1}" # TODO: Pad this number correctly
  description = "Node in the ${var.cluster_name} k3s cluster and managed by Terraform. Created on ${formatdate("MMM DD, YYYY")} at ${formatdate("H:mm:ss AA")}"
  tags        = ["k3s", "terraform"]

  # Balances workers across all nodes
  node_name   = proxmox_virtual_environment_nodes.available_nodes[(count - 1) % length(proxmox_virtual_environment_nodes.available_nodes) + count.index]

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
}
