## What this role does
* Checks connectivity before running tasks
* Drains the worker node
* Waits for 30 seconds so all pods would be evicted gracefully
* Updating the repo on the worker
* Unholding kubectl and kubelet on worker
* Updating kubelet and kubectl on worker node
* Marking the packages as hold so they would not be updated accidentlaly
* Reload systemd daemon
* Restart kubelet
* Uncordon the node
* Waits for cluster to utilize the resources