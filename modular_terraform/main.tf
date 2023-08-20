
module "ssh_keys" {
  source = "./modules/ssh_keys"
  hcloud_token = var.hcloud_token

}


module "servers" {
  source       = "./modules/servers"
  hcloud_token = var.hcloud_token
  image_name   = var.image_name
  server_type  = var.server_type
  location     = var.location
  depends_on   = [module.ssh_keys]
}

module "volume" {
  source = "./modules/volume"
  hcloud_token = var.hcloud_token
  depends_on = [module.servers]

}

#module "firewall" {
#  source = "./modules/firewall"
#  hcloud_token = var.hcloud_token
#  depends_on = [module.servers]
#}

module "k8s" {
  source = "./modules/k8s"
  hcloud_token = var.hcloud_token
  #depends_on = [module.firewall]

}
