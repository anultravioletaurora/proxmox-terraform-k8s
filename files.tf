resource "proxmox_virtual_environment_file" "debian_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_node

  source_file {
    path      = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
    file_name = "jammy-server-cloudimg-amd64.img"
  }
}

# Creates a cloud init drive on all nodes
resource "proxmox_virtual_environment_file" "cloud_config" {

  count = length(proxmox_virtual_environment_nodes.available_nodes)

  content_type = "snippets"
  datastore_id = "local"
  node_name    = proxmox_virtual_environment_nodes.available_nodes[count.index]

  source_raw {
    data = templatefile("${path.module}/cloud-init/config.tftpl", { username = var.username, ssh_key = file("~/.ssh/id_rsa.pub")})
  }
}
