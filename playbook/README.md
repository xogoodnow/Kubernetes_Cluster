## What this playbook does
* Prepares cluster nodes for k8s set up
* Installs kubeadm kubectl and kubelet on cluster nodes
* Sets up the haproxy for control plain
* Initializes the cluster on master-0 node
* Creates the join command and joins other masters and workers
  * At this part "serial=1" is used to prevent any conflict while adding nodes to the cluster
* Sets up CSI and CNI for the master-0 (Openebs and Calico)
* Installs Ingress Controller
* Installs Cert Manager
* Sets up monitoring on the cluster
* Exposing metrics on main cluster components
* Creates a backup job for etcd data
* Deploying EFK stack
  * Set up elasticsearch
  * Setup Fluentbit
  * Setup Kibana
