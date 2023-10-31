provider "hcloud" {
    token = "${var.hcloud_token}"
}

provider "tailscale" {
    oauth_client_id = "${var.tailscale_client_id}"
    oauth_client_secret = "${var.tailscale_client_secret}"
    tailnet = "-"
    base_url = "https://api.tailscale.com"
}

# create auth key 
resource "tailscale_tailnet_key" "setup_key" {
    reusable      = "${var.reusable}"
    ephemeral     = "${var.ephemeral}"
    preauthorized = "${var.preauthorized}"
    expiry        = "${var.expiry}"
    description   = "${var.description}"
    tags = "${var.tags}"
}

locals {
  user_data_complete = "#cloud-config\nshell: /bin/bash\nruncmd:\n- curl -fsSL https://tailscale.com/install.sh --output /tmp/install.sh\n- chmod +x /tmp/install.sh\n- /tmp/install.sh\n- tailscale up --authkey=${tailscale_tailnet_key.setup_key.key} --ssh"
  user_data_command_only ="- curl -fsSL https://tailscale.com/install.sh --output /tmp/install.sh\n- chmod +x /tmp/install.sh\n- /tmp/install.sh\n- tailscale up --authkey=${tailscale_tailnet_key.setup_key.key} --ssh"
}

resource "hcloud_server" "server" {
    name        = "${var.name}"
    image       = "${var.image}"
    server_type = "${var.server_type}"
    datacenter  = "${var.datacenter}"
    ssh_keys = "${var.ssh_keys}"
    firewall_ids = "${var.firewall_ids}"
    user_data = var.user_data != "" ? "${var.user_data}${local.user_data_command_only}" : "${local.user_data_complete}"
}