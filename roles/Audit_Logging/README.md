## What this role does
* Checks connectivity before running tasks
* Creates the directory for storing audit logs
* Deletes the manifest for kube-apiserver
* Creates the new manifest (based on the IP address of the current host)
* Restarts kubelet so new manifest would be applies (Since api server is static, kubelet controlls it)
* Waits for kubeapi to be ready
* The blockinfile module did not work as expected and crashed the api server

