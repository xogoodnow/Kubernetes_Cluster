## What this role does
* Checks connectivity before running tasks
* Drains the worker node
* waits for 30 seconds so pods would be evicted gracefully
* Updates the repo
* Unholding kubelet and kubeclt so they could be updated
* Updating the version of kubelet and kubectl to 1.26
* holding the packages so they won't be updated accidenrtally
* Reloading systemctl daemon
* Restarts kubelet
* Uncordon the worker node
* waits for 30 seconds before updating the next node
