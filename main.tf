terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.21.1"
    }
  }
}

provider "proxmox" {
  virtual_environment {
    endpoint = "https://<your proxmox ip>:8006/"
  }
}
