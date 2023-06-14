variable "machine_name" {
  type = string
  description = "The name of the machines in the cluster, will be used when naming nodes"
  default = "k3s"
}

variable "username" {
  type = string 
  description = "The SSH username"
}
