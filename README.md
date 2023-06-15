# proxmox-terraform-k8s
Terraform project for spinning up a k8s cluster on Proxmox

This will spin up multiple control plane servers in an embedded DB HA mode, and will create as many worker nodes as you like. 

### Uses:
- https://github.com/bpg/terraform-provider-proxmox
- https://github.com/alexellis/k3sup

### Resources
- https://cloudinit.readthedocs.io/en/latest/index.html
- https://olav.ninja/deploying-kubernetes-cluster-on-proxmox-part-1
- https://nimblehq.co/blog/provision-k3s-on-google-cloud-with-terraform-and-k3sup#terraform-apply
