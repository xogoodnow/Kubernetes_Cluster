## What this role does
* Checks connectivity before running tasks
* Installing some base packages
* Creates a directory for keyring
* Getting the gpg key of docker
*  Adding docker repo
* Updating the repo
* Installs docker
* Installs dockerpy so we can modify docker using ansible
* Pulling haproxy latest image
* Creating a directory for haproxy config
* render haproxy.cfg file based on the ip addresses of master nodes
* Using the config file, set ups the container for haproxy