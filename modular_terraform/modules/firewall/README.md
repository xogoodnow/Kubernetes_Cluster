## What this module does

* Creates a firewall (Security group) on hetzner 
* Records the IP address of every provisioned hosts
* Allows ssh connection from the bastion server only
* Allowing inbound to master nodes through workers only
* Limits the outbound and inbound through the cluster
* Attaches the firewall to every host which is provisioned in .state file
* Documentaion through here
  * [Hetzner Firewall Terraform](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall) Support

