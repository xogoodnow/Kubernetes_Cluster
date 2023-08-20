
# Update and upgrdae the OS (on all nodes)

``` bash
apt update -y
apt upgrade -y
```

# Install ETCD (on all nodes)
#### Download the binary of etcd (at this time the latest version is 3.5.9)
``` bash
wget https://github.com/etcd-io/etcd/releases/download/v3.5.9/etcd-v3.5.9-linux-amd64.tar.gz
```
#### Extract the contents
``` bash
tar -xvzf etcd-v3.5.9-linux-amd64.tar.gz 
rm etcd-v3.5.9-linux-amd64.tar.gz 
mv etcd-v3.5.9-linux-amd64/ etcd

```
#### Move the required binaries to /bin
``` bash
cd etcd/
mv etcd etcdctl etcdutl /usr/local/bin

```

#### Check if everything works fine so far
``` bash
etcd --version
```


# Certificates (On etcd NO.1)

#### Create a directory for certificate generation 
``` bash
mkdir etcd-certs
cd /etcd-certs
```
#### Create a key for certificate authority
``` bash
openssl genrsa -out ca-key.pem 4096
```
#### Create the certificate signing request
``` bash
openssl req -new -key ca-key.pem -subj "/CN=etcd CA" -out ca-csr.pem
```


#### Sign the request with the ca key 
``` bash
openssl x509 -req -in ca-csr.pem -signkey ca-key.pem -out ca.pem -days 36500
```



#### Create a key for the etcd certificate
``` bash
openssl genrsa -out member-key.pem 4096
```
#### Create the config for the signing request
``` bash
vi member.cnf

```
```angular2html
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
IP.1 = <Etcd Node 1>
IP.2 = <Etcd Node 2>
IP.3 = <Etcd Node 3>
```


#### Create a certificate signin request on etcd certificate
``` bash
openssl req -new -key member-key.pem -subj "/CN=etcd" -out member-csr.pem -config member.cnf
```


#### Sign the certificate using the CA
``` bash
openssl x509 -req -in member-csr.pem -CA ca.pem -CAkey ca-key.pem -out member.pem -days 36500 -extensions v3_req -extfile member.cnf
```

#### Craete a directory for the certs and keys to be used by ETCD
``` bash
mkdir -p /etc/etcd/pki
mv  ca.pem member-key.pem member.pem /etc/etcd/pki/
```



#### Create the config file for the first ETCD
``` bash
vi /etc/etcd/etcd.conf.yml
```

``` angular2html
name: 'ETCD_1'
data-dir: '/var/lib/etcd'
listen-peer-urls: 'https://<VM1_IP>:2380'
listen-client-urls: 'https://<VM1_IP>:2379'
advertise-client-urls: 'https://<VM1_IP>:2379'
initial-advertise-peer-urls: 'https://<VM1_IP>:2380'
initial-cluster: 'node1=https://<VM1_IP>:2380,node2=https://<VM2_IP>:2380,node3=https://<VM3_IP>:2380'
initial-cluster-state: 'new'
initial-cluster-token: 'etcd-cluster'
client-transport-security:
  cert-file: '<PATH_TO_MEMBER_CERT>'
  key-file: '<PATH_TO_MEMBER_KEY>'
  trusted-ca-file: '<PATH_TO_CA_CERT>'
peer-transport-security:
  cert-file: '<PATH_TO_MEMBER_CERT>'
  key-file: '<PATH_TO_MEMBER_KEY>'
  trusted-ca-file: '<PATH_TO_CA_CERT>'

```






# Configuration for other ETCDs (On 2nd and 3rd ETCD nodes)

#### Create the directory for the keys and cets
```bash
mkdir -p /etc/etcd/pki
```
#### Copy the content of ca.pem member-key.pem member.pem to both servers

``` bash
scp -i ~/.ssh/id_rsa /etc/etcd/pki/ca.pem /etc/etcd/pki/member-key.pem /etc/etcd/pki/member.pem <USERNAME>@<IP_OF_ETCD(2..3)>:/etc/etcd/pki/
```


#### Create the ETCD config files
``` bash
vi /etc/etcd/etcd.conf.yml
```

#### Config file for ETCD_2
``` bash
name: 'ETCD_2'
data-dir: '/var/lib/etcd'
listen-peer-urls: 'https://<VM2_IP>:2380'
listen-client-urls: 'https://<VM2_IP>:2379'
advertise-client-urls: 'https://<VM2_IP>:2379'
initial-advertise-peer-urls: 'https://<VM2_IP>:2380'
initial-cluster: 'node1=https://<VM1_IP>:2380,node2=https://<VM2_IP>:2380,node3=https://<VM3_IP>:2380'
initial-cluster-state: 'new'
initial-cluster-token: 'etcd-cluster'
client-transport-security:
  cert-file: '<PATH_TO_MEMBER_CERT>'
  key-file: '<PATH_TO_MEMBER_KEY>'
  trusted-ca-file: '<PATH_TO_CA_CERT>'
peer-transport-security:
  cert-file: '<PATH_TO_MEMBER_CERT>'
  key-file: '<PATH_TO_MEMBER_KEY>'
  trusted-ca-file: '<PATH_TO_CA_CERT>'

```

#### Config file for ETCD_3
``` bash
name: 'ETCD_3'
data-dir: '/var/lib/etcd'
listen-peer-urls: 'https://<VM3_IP>:2380'
listen-client-urls: 'https://<VM3_IP>:2379'
advertise-client-urls: 'https://<VM3_IP>:2379'
initial-advertise-peer-urls: 'https://<VM3_IP>:2380'
initial-cluster: 'node1=https://<VM1_IP>:2380,node2=https://<VM2_IP>:2380,node3=https://<VM3_IP>:2380'
initial-cluster-state: 'new'
initial-cluster-token: 'etcd-cluster'
client-transport-security:
  cert-file: '<PATH_TO_MEMBER_CERT>'
  key-file: '<PATH_TO_MEMBER_KEY>'
  trusted-ca-file: '<PATH_TO_CA_CERT>'
peer-transport-security:
  cert-file: '<PATH_TO_MEMBER_CERT>'
  key-file: '<PATH_TO_MEMBER_KEY>'
  trusted-ca-file: '<PATH_TO_CA_CERT>'
```



# Service for ETCD (On all nodes)
``` bash
vi /etc/systemd/system/etcd.service
```
```angular2html
[Unit]
Description=etcd - highly-available key value store
After=network.target
Wants=network-online.target

[Service]
Type=simple
PermissionsStartOnly=true
ExecStart=/usr/local/bin/etcd --config-file /etc/etcd/etcd.conf.yml
Restart=on-abnormal
#RestartSec=10s

[Install]
WantedBy=multi-user.target
Alias=etcd.service

```


#### Reload the systemd daemon
``` bash
systemctl daemon-reload
```

#### Enable and restart ETCD
``` bash
systemctl enable etcd
systemctl restart etcd
```

#### Check if everything is ok so far
``` bash
systemctl status etcd
```




# Check functionality (On all nodes)

#### Using the following command you can check if everything works fine so far
``` bash
etcdctl --endpoints=https://<IP_OF_ETCD_PEER>:2379 --cacert=/etc/etcd/pki/ca.pem --cert=/etc/etcd/pki/member.pem --key=/etc/etcd/pki/member-key.pem endpoint health
```


# Initializing the K8S cluster (On the initiating master node)

#### Create the following directory for certs and keys
``` bash
mkdir -p /etc/kubernetes/pki/etcd/
```

#### Copy the certs and keys to the master
``` bash
scp -i ~/.ssh/id_rsa /etc/etcd/pki/member-key.pem /etc/etcd/pki/member.pem <USERNAME>@<IP_OF_ETCD(2..3)>:/etc/kubernetes/pki/
```
``` bash
scp -i ~/.ssh/id_rsa /etc/etcd/pki/ca.pem <USERNAME>@<IP_OF_Master>:/etc/kubernetes/pki/etcd/
```
#### For better readability change the names of certs and keys
```bash
mv /etc/kubernetes/pki/member-key.pem /etc/kubernetes/pki/apiserver-etcd-client.key
mv /etc/kubernetes/pki/member.pem /etc/kubernetes/pki/apiserver-etcd-client.crt
mv /etc/kubernetes/pki/etcd/ca.pem /etc/kubernetes/pki/etcd/ca.crt
```



#### Craete a directory for kubeadm config
``` bash
mkdir kubead_config
cd kubead_config
```

#### Create the config file for kubeadm
``` bash
vi kubeadm-config.yaml
```
``` bash
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: stable
controlPlaneEndpoint: "<LOAD_BALANCER_IP>:6443"
etcd:
  external:
    endpoints:
    - https://<ETCD1_IP>:2379
    - https://<ETCD2_IP>:2379
    - https://<ETCD3_IP>:2379
    caFile: /etc/kubernetes/pki/etcd/ca.crt
    certFile: /etc/kubernetes/pki/apiserver-etcd-client.crt
    keyFile: /etc/kubernetes/pki/apiserver-etcd-client.key
networking:
  podSubnet: "192.168.0.0/16"
#Used "192.168.0.0/16" since it is the default subnet for calico
```

#### Initialize the cluster using the following command
``` bash
kubeadm init --config=/kubead_config/kubeadm-config.yaml --upload-certs --v=5
```
#### Join other master nodes and workers and check if they are ready
```bash
kubectl get nodes -o wide
```


# Using the follwing command you can check the functionality of the cluster (On initiating master)
#### Take a snapshot of the etcd
``` bash
ETCDCTL_API=3 etcdctl --endpoints=https://<ETCD_IP>:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/apiserver-etcd-client.crt --key=/etc/kubernetes/pki/apiserver-etcd-client.key snapshot save /tmp/etcd-backup.db

```
#### Also using the following command you can check if there are any terrafic between your master and ETCD nodes
```bash
tcpdump -pnni any host <IP_OF_ETCD>
```
#### You can also see that there are no internal etcd pods on any of the nodes
``` bash
kubectl get po -A
```



