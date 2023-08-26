## What this role does
* Checks connectivity before running tasks
* Updating the repo
* Unholding kubeadm so it could be updated
* Installing Kubeadm version 1.26
* Hold kubeadm again so it would not be updated accidentally
* Verify if upgrade is compatible with current configuration
* If everything is acceptable
* Upgrade kubeadm on the cluster
