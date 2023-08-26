## What this role does
* Checks connectivity before running tasks
* Creates a directory for elastic helm chart
* Copy the chart to the directory
* Add a specific namespace 
* Verify if helm is installed
* Wait for 40 seconds for elastic to be ready
* After the opertor is ready, apply the elastic manifest
* Wait for elastic to be ready and green