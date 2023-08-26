## What this role does
* Checks connectivity before running tasks
* Updating repo and upgrading the nodes
* Installing some base packages on all nodes
* Adding 8.8.8.8 as the nameserver on all nodes
* Nameserver management is delegated to resolvconf package
* Installing k8s module on all nodes (For ansible k8s module to be able to work on them)