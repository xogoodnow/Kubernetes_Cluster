## Whta this role does
* Checks connectivity before running tasks
* Using kubeadm extracts the certificates of the cluster
* Generates a token using kubeadm
* Craetes the join command via the token whcih was just created
* Joins the masters to the control plain
* Craetes a direcotory for kubeconfig
* Exposes the kubeconfig to root user home directory so kubectl becomes functional
