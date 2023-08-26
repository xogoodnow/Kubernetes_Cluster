## What does main.tf do
* Creates ssh keys 
* Creates servers according to specification in the module
* Creates volumes for each worker node according to specification
* Creates the firewall and attaches it to the nodes
* Runs the ansible to set up the cluster

> **Note**
> Remember to add terraform.tfvars
> 
