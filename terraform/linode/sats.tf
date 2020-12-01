provider "linode" {
  token = var.token
}
resource "linode_instance" "sats" {
  label           = var.label
  region          = var.region
  type            = "g6-nanode-1"
  image           = var.image
  authorized_keys = [var.ssh_key]
  root_pass       = var.root_pass
}

output "ip" {
  value = linode_instance.sats.ip_address
}
     
variable "image"      {}
variable "admin"      {}
variable "mew_token"  {}
variable "root_pass"  {}
variable "ssh_key"    {}
variable "token"      {}
variable "disk_space" {}
variable "region"     {}
variable "label"      {}
