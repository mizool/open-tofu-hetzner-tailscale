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

resource "hcloud_server" "server" {
    name        = "${var.name}"
    image       = "${var.image}"
    server_type = "${var.server_type}"
    datacenter  = "${var.datacenter}"
    ssh_keys = "${var.ssh_keys}"

    connection {
        type = "ssh"
        user = "root"
        host = self.ipv4_address
        private_key = file("${var.private_key_path}")
    }

    provisioner "remote-exec" {
        inline = [
            "curl -fsSL https://tailscale.com/install.sh --output /tmp/install.sh",
            "chmod +x /tmp/install.sh",
            "/tmp/install.sh",
            "tailscale up --authkey=${tailscale_tailnet_key.setup_key.key} --ssh"
        ]
    }
}