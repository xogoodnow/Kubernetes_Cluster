## What this role does
* Creates the directory Calico manifests
* Downloading the operator 
* downloading resources manifest
* Installing calico on the system
* Waits for 40 seconds for operator to be ready 
  * (The time is a bit overkill but better to be safe than sorry)
* Apply the resources manifest
* Waiting for 40 seconds for calico to be ready
