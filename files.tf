resource "proxmox_virtual_environment_file" "debian_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "<your proxmox node>"

  source_file {
    path      = "https://cloud.debian.org/images/cloud/bookworm/20230612-1409/debian-12-genericcloud-arm64-20230612-1409.qcow2"
    file_name = "debian-12-genericcloud-arm64-20230612-1409.qcow2"
    checksum  = "61358292dbec302446a272d5011019091ca78e3fe8878b2d67d31b32e0661306c53a72f793f109394daf937a3db7b2db34422d504e07fdbb300a7bf87109fcf1"
  }
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "<your proxmox node>"

  source_file {
    path = "cloud-init/user-data.yml"
  }
}
