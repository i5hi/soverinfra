provider "digitalocean"{
  token = var.token
}
resource "digitalocean_droplet" "msats" {
  name            = var.label
  region          = var.region
  size            = var.size
  image           = var.image
  ssh_keys        = [var.ssh_key]
}
resource "digitalocean_volume_attachment" "s5persistence" {
  droplet_id = digitalocean_droplet.msats.id
  volume_id  = var.volume_id
}
resource "digitalocean_firewall" "msats" {
  name = "only-22-80-and-443"

  droplet_ids = [digitalocean_droplet.msats.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol	     = "tcp"
    port_range       = 22909
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
 
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

output "ip" {
  value           = digitalocean_droplet.msats.ipv4_address
}

variable "image"      {}
variable "admin"      {}
variable "ssh_key"    {}
variable "token"      {}
variable "size"       {}
variable "region"     {}
variable "label"      {}
variable "volume_id"  {}

provider "cloudflare" {
  version    = "~> 2.0"
  api_token  = var.cf_token

}

resource "cloudflare_record" "api" {
  type    = "A"
  name    = "api"
  zone_id = "6666d582642b862661259157df6ca73f"
  value   = digitalocean_droplet.msats.ipv4_address
}

variable "cf_key"       {}
variable "cf_token"     {}
variable "cf_email"     {}
variable "cf_zone_id"   {}

// curl -X GET "https://api.cloudflare.com/client/v4/zones" \
//     -H "X-Auth-Email: vishalmenon.92@gmail.com" \
//     -H "X-Auth-Key: 06cf8c8e20c290e3516365445d6f14bd34173" \
//     -H "Content-Type: application/json"
