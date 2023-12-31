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
    endpoint = "https://${var.proxmox_api_ip}:8006/"
    username = var.proxmox_username
    password = var.proxmox_password
    insecure = true
  }
}
