
data "hcloud_server" "workers" {
  count = 4
  name = "worker-${count.index}"

}

resource "hcloud_volume" "worker_volumes" {
  count = length(data.hcloud_server.workers)
  name  = "worker-${count.index}-volume"
  size  = 200
  server_id = data.hcloud_server.workers[count.index].id
}