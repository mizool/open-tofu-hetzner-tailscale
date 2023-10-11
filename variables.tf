terraform {
    required_providers {
        hcloud = {
            source = "hetznercloud/hcloud"
        }
        tailscale = {
            source = "tailscale/tailscale"
            version = "0.13.11"
        }
    }
    required_version = ">= 0.13"
}

#hetzner
variable "hcloud_token" {}
variable "name" {
  type = string
}
variable "image" {
  type = string
  default = "ubuntu-22.04"
}
variable "server_type" {
  type = string
  default = "cx11"
}
variable "datacenter" {
  type = string
  default = "nbg1-dc3"
}
variable "ssh_keys" {
    type = list(number)
}
variable "private_key_path" {
  type = string
}

#tailscale
variable "tailscale_client_id" {}
variable "tailscale_client_secret" {}
variable "description" {
  type = string
}
variable "tags" {
  type = list(string)
}