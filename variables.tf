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
variable "hcloud_token" {
  type = string
  description = "API key needed to communicate with the Hetzner cloud. Also defines the project where the server is created."
}
variable "name" {
  type = string
  description = "Name of the server to create (must be unique per project and a valid hostname as per RFC 1123)"
}
variable "image" {
  type = string
  default = "ubuntu-22.04"
  description = "Name or ID of the image the server is created from."
}
variable "server_type" {
  type = string
  default = "cx11"
  description = "Name of the server type this server should be created with."
}
variable "datacenter" {
  type = string
  default = "nbg1-dc3"
  description = "The datacenter name to create the server in. nbg1-dc3, fsn1-dc14, hel1-dc2, ash-dc1 or hil-dc1"
}
variable "ssh_keys" {
    type = list(number)
    description = "SSH key IDs or names which should be injected into the server at creation time. At least during creation time this is needed as a remote exec is neccessary for the installation of tailscale"
}
variable "private_key_path" {
  type = string
  description = "Path to the private key matching to one public key configured in ssh_keys"
}

#tailscale
variable "reusable" {
  type = bool
  default = false
  description = "Indicates if the key is reusable or single-use."
}
variable "ephemeral" {
  type = bool
  default = true
  description = "Indicates if the key is ephemeral."
}
variable "preauthorized" {
  type = bool
  default = true
  description = "Determines whether or not the machines authenticated by the key will be authorized for the tailnet by default."
}
variable "expiry" {
  type = number
  default = 3600
  description = "The expiry of the key in seconds"
}
variable "tailscale_client_id" {
  type = string
  description = "The OAuth application's ID when using OAuth client credentials."
}
variable "tailscale_client_secret" {
  type = string
  description = " The OAuth application's secret when using OAuth client credentials."
}
variable "description" {
  type = string
  description = "A description of the key consisting of alphanumeric characters."
}
variable "tags" {
  type = list(string)
  description = "List of tags to apply to the machines authenticated by the key."
}