variable "cp_cores" {
  type = number
  description = "The number of cores for the control plane machine(s)"
  default = 2
}

variable "cp_memory" {
  type = number
  description = "The amount of memory for the control plane machine(s)"
  default = 4096
}

variable "cp_disk_size" {
  type = number
  description = "The amount of disk space in GBs for the control plane machine(s)"
  default = 40
}

variable "k3s_version" {
  type = string
  description = "The k3s version to install across the cluster"
  default = "v1.27.2+k3s1"
}

variable "machine_name" {
  type = string
  description = "The name of the machines in the cluster, will be used when naming nodes"
  default = "k3s"
}

variable "proxmox_api_ip" {
  type = string
  description = "The IP of the API for the Proxmox cluster"
}

variable "proxmox_node" {
  type = string
  description = "The node of the Proxmox cluster to deploy to"
}

variable "proxmox_username" {
  type = string
  description = "The username of the Proxmox user"
}

variable "proxmox_password" {
  type = string
  description = "The password of the Proxmox user"
}

variable "username" {
  type = string 
  description = "The SSH username"
}
  
variable "worker_cores" {
  type = number
  description = "The number of cores for the worker machine(s)"
  default = 2
}

variable "worker_count" {
  type = number
  description = "The number of workers to create"
  default = 1
}

variable "worker_memory" {
  type = number
  description = "The amount of memory for the worker machine(s)"
  default = 4096
}

variable "worker_disk_size" {
  type = number
  description = "The amount of disk space in GBs for the worker machine(s)"
  default = 40
}
