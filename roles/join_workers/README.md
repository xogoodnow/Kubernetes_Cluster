## What this role does
* Checks connectivity before running tasks
* Creates a token on kubeadm (on master-0 whcih the cluster was initiated on)
* Creates join commadn with the token which was just created
* Joins worker nodes to cluster
* Exposing kube config on nodes