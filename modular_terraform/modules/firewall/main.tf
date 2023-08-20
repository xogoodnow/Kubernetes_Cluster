data "hcloud_server" "masters" {
  count = 3
  name  = "master-${count.index}"
}

data "hcloud_server" "workers" {
  count = 3
  name  = "worker-${count.index}"
}

data "hcloud_server" "haproxy" {
  name = "haproxy"
}



resource "hcloud_firewall" "k8sfirewall" {
  name = "k8sfirewall"

  rule {
    description = "Allow all tcp connection within the cluster (inbound)"
    direction = "in"
    protocol = "tcp"
    port = "any"
    source_ips = formatlist("%s/32", concat(data.hcloud_server.masters.*.ipv4_address, data.hcloud_server.workers.*.ipv4_address, [data.hcloud_server.haproxy.ipv4_address], ["65.109.165.149"]))
    destination_ips = ["0.0.0.0/0", "::/0"]
  }

    rule {
    description = "Allow all tcp connection within the cluster (outbound)"
    direction = "out"
    protocol = "tcp"
    port = "any"
    source_ips = formatlist("%s/32", concat(data.hcloud_server.masters.*.ipv4_address, data.hcloud_server.workers.*.ipv4_address, [data.hcloud_server.haproxy.ipv4_address], ["65.109.165.149"]))
    destination_ips = ["0.0.0.0/0", "::/0"]
  }

    rule {
    description = "Allow all udp connection within the cluster (inbound)"
    direction = "in"
    protocol = "udp"
    port = "any"
    source_ips = formatlist("%s/32", concat(data.hcloud_server.masters.*.ipv4_address, data.hcloud_server.workers.*.ipv4_address, [data.hcloud_server.haproxy.ipv4_address], ["65.109.165.149"]))
    destination_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    description = "Allow all udp connection within the cluster (outbound)"
    direction = "out"
    protocol = "udp"
    port = "any"
    source_ips = formatlist("%s/32", concat(data.hcloud_server.masters.*.ipv4_address, data.hcloud_server.workers.*.ipv4_address, [data.hcloud_server.haproxy.ipv4_address], ["65.109.165.149"]))
    destination_ips = ["0.0.0.0/0", "::/0"]
  }



  rule {
    description = "Rule for Kubernetes API Server and HTTPS"
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
    destination_ips = ["0.0.0.0/0", "::/0"]
  }


  rule {
    description = "Rule for NodePort service range"
    direction = "in"
    protocol  = "tcp"
    port      = "30000-32767"
    source_ips = ["0.0.0.0/0", "::/0"]
    destination_ips = ["0.0.0.0/0", "::/0"]
  }


  rule {
    description = "Enabled ssh from ansible master and all cluster nodes"
    direction = "in"
    protocol  = "tcp"
    port = "22"
    source_ips = formatlist("%s/32", concat(data.hcloud_server.masters.*.ipv4_address, data.hcloud_server.workers.*.ipv4_address, [data.hcloud_server.haproxy.ipv4_address], ["65.109.165.149"]))
    destination_ips = ["0.0.0.0/0", "::/0"]
  }



  rule {
    description = "Rule for DNS"
    direction = "in"
    protocol  = "udp"
    port      = "53"
    source_ips = ["0.0.0.0/0", "::/0"]
    destination_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    description = "Rule for dhcp"
    direction = "in"
    protocol  = "udp"
    port      = "68"
    source_ips = ["0.0.0.0/0", "::/0"]
    destination_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    description = "Rule for http"
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
    destination_ips = ["0.0.0.0/0", "::/0"]
  }


}

resource "hcloud_firewall_attachment" "k8sfw" {
  firewall_id = hcloud_firewall.k8sfirewall.id
  server_ids = concat(data.hcloud_server.masters.*.id , data.hcloud_server.workers.*.id, [data.hcloud_server.haproxy.id] )
}



