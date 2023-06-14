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

variable "username" {
  type = string 
  description = "The SSH username"
}
  
variable "worker_cores" {
  type = number
  description = "The number of cores for the worker machine(s)"
  default = 2
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
