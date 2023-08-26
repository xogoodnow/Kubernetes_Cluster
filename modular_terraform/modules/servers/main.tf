resource "hcloud_server" "master" {
  count = 3
  name         = "master-${count.index}"
  image        = var.image_name
  server_type  = "cpx31"
  ssh_keys = [data.hcloud_ssh_key.key1.id,data.hcloud_ssh_key.key2.id,data.hcloud_ssh_key.key3.id]
  location = var.location

}


resource "hcloud_server" "worker" {
  count = 4
  name         = "worker-${count.index}"
  image        = var.image_name
  server_type  = "cpx31"
  ssh_keys = [data.hcloud_ssh_key.key1.id,data.hcloud_ssh_key.key2.id,data.hcloud_ssh_key.key3.id]
  location = var.location

}


resource "hcloud_server" "haproxy" {
  name         = "haproxy"
  image        = var.image_name
  server_type  = "cpx11"
  ssh_keys = [data.hcloud_ssh_key.key1.id,data.hcloud_ssh_key.key2.id,data.hcloud_ssh_key.key3.id]
  location = var.location

}



data "hcloud_ssh_key" "key1"  {
  name = "kang"

}

data "hcloud_ssh_key" "key2"  {
  name = "Kangkey"

}

data "hcloud_ssh_key" "key3" {
  name = "my_ssh_key"

}



resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tpl",
    {
      master_ips = hcloud_server.master.*.ipv4_address
      worker_ips = hcloud_server.worker.*.ipv4_address
      haproxy_ip = hcloud_server.haproxy.ipv4_address
    }
  )
  filename = "${path.module}/../../inventory.yaml"
}
