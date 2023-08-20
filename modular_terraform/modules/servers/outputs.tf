output "master_ips" {
  value = hcloud_server.master[*].ipv4_address
}

output "worker_ips" {
  value = hcloud_server.worker[*].ipv4_address
}

output "haproxy_ip" {
  value = hcloud_server.haproxy.ipv4_address
}

