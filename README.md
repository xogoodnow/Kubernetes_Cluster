
<div align="center">
    <h1>Production Ready K8s cluster</h1>
    <i>A K8S cluster implementation ready for heavy production load</i>

</div>

### Components Used
 Name    : Version                                                                                                             | Purpose                                 | Alternatives                                    | Advantages                                                                                                                                                                                                                                                     |
|-------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------|-------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Terraform 1.5.4 [Docs](https://developer.hashicorp.com/terraform?product_intent=terraform)                                    | Hardware Provisioner <br/>Initial Setup | `Salt` `Anible`                                 | 1. Easy syntax<br/>2. Sufficient community and documentation<br/>3. Much better suited for hardware provisioning                                                                                                                                               |
| Hetzner Provider 1.42.1 [Docs](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs)                       | Deploying servers                       | `Vultr` `DigitalOcean`                          | 1. Cheaper :)<br/>2. Good community overlooking provider                                                                                                                                                                                                       | 
| Ansible 1.5.6 [Docs](https://docs.ansible.com/)                                                                               | Automating Tasks                        | `Salt`                                          | 1. No footprint on target hosts                                                                                                                                                                                                                                |
| Helm  3.12.2 [Docs](https://helm.sh/docs/)                                                                                    | Resource Controll                       | `Non-I-know-Of`                                 | :)                                                                                                                                                                                                                                                             |
| S3cmd 2.3.0 [Docs](http://www.colourlovers.com/api)                                                                           | Backup on 3s                            | `Cyberduck` `Rclone`                            | 1. Easey to setup<br/>2. Huge community and documentation<br/>3. Python (Easy to customize if needed)                                                                                                                                                          |
| K8s 1.25.0-00 [Docs](https://git.k8s.io/kubernetes/CHANGELOG/CHANGELOG-1.25.md#v1250)                                         | Orchestrator                            | `Docker Swarm` `Nomad`                          | 1. k8s to swarm is like ocean to a puddle<br/>2. Nomad is quite greate (Needs R&D)                                                                                                                                                                             |
| Cri-o 1.24.6 [Docs](https://github.com/cri-o/cri-o/releases/tag/v1.24.0)                                                      | Container Runtime Interface             | `Containerd`                                    | 1. Very efficient<br/>2. Supported by k8s sigs<br/>3. Very light (But lacks some functionality)                                                                                                                                                                |
| Nginx Ingress Controller Chart: 0.18.1 [Docs](https://docs.nginx.com/nginx-ingress-controller/)                               | Ingress Controller                      | `Traefik` `Api Gateway`                         | 1. Much faster that Traefik<br/>2. Proven on production<br/>3. Good community and documentation<br/>4. Api Gateway is quite amazing (Needs R&D)                                                                                                                |
| Openebs Cstore 3.8.0 [Docs](https://openebs.io/docs/concepts/cstor)                                                           | Storage Solution                        | `Openebs (Jiva)` `Ceph fs` `Rook fs` `Longhorn` | 1. Much less complex than ceph on both setup and management<br/>2. Good community and documentation<br/>3. Longhorn is quite nice (Needs R&D)                                                                                                                  |
| Ubuntu  22.04 [Docs](https://www.google.com/search?client=safari&rls=en&q=ubuntu+image+22.04&ie=UTF-8&oe=UTF-8)               | Operating system                        | `Debian` `Centos`                               | 1. Bigger community<br/>2. Faster releases than debian<br/>3. Bigger community than any other OS<br/>4. Not cash grapping like centos (Yet :))                                                                                                                 |
| Cert Manager Chart: v1.12.3 [Docs](https://www.nginx.com/blog/automating-certificate-management-in-a-kubernetes-environment/) | Certificate Controller                  | `Non-I-know-Of`                                 | :)                                                                                                                                                                                                                                                             |
| Fluentbit Chart: 0.37.1[Docs](https://github.com/fluent/helm-charts)                                                          | Log Collctor/Shipper                    | `Logstash` `fluentd`                            | 1. No seperate component for shipper and collector<br/>2. No extra dependency<br/>3. Very efficient (faster than fluentd)<br/>4. Almost zero foot print (Comparing to alternatives)<br/>5. Much easier to setup and manage<br/>6. Good number of useful plugins |
| Elaticsearch Chart: 2.9.0 [Docs](https://www.elastic.co/guide/en/cloud-on-k8s/master/k8s-install-helm.html)                   | Log Analysis                            | `Loki`                                          | 1. More rigorious indexing<br/>2. Loki needs more R&D                                                                                                                                                                                                          |
| Kube Prometheus Stack [Docs](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)      | Monitoring                              | `Prometheus`+`Grafana`                          | 1. One single chart (so easier to manage and setup)<br/>2. Preconfigured for k8s components<br/>                                                                                                                                                               |
| Haproxy latest [Docs](https://hub.docker.com/_/haproxy/)                                                                      | Control plain loadbalancer              | `CDN`                                           | 1. Easier to setup<br/> 2. Custome health check rules<br/>3. Since cluster is initiated on domain, CDN can be used too                                                                                                                                         |
| Calico 3.26.1 [Docs](https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises)          | Container Network Interface             | `Flannel` `Cillium` `Canal`                      | 1. Support for network policy<br/>2. Multi AZ support<br/>3. Quite easy to setup<br/>4. Great documentation and community<br/>5. eFFICIENT l3 NETWORK<br/>6. Configureable BGP (bird agent)                                                                    |
| Kibana 8.9.1 [Docs](https://www.elastic.co/guide/en/cloud-on-k8s/master/k8s-deploy-kibana.html)                               | Log Visualizer                          | `Grafana` `Datadog`                             | 1. Free (comparing to datadog which is awsome)<br/>2. Customized specifically for ealstic search so they are much more compatible<br/>3. Easier to setup<br/>4. Very light weight                                                                              |



## Before you begin
> **Note**
> Each ansible role has a general and a specific Readme file. It is strongly encouraged to read them before firing off
> 
> p.s: Start with the readme file of main setup playbook
* Create an Api on hetzner
* Create a server as terraform and ansible provisioner (Needless to say that ansible and terraform must be installed)
* Clone the project
* In modular_terraform folder create a terraform.tfvars 
    - The file must contain the following variables
      - hcloud_token "APIKEY"
      - image_name = "ubuntu-22.04"
      - server_type = "cpx31"
      - location = "hel1"
* Run terraform init to create the required lock file
* Before firing off, run terraform plan to see if everything is alright
* Run terraform apply
* Go drink a cup of coffe and come back in 30 minutes or so (Hopefully everything must be up and running by then (: )


## Known issues
* When creating SDS, Coredns and webhook addmision controller must be deleted other wise CSPC would not be applied correctly
* No alert manager
* Haproxy could be a single point of failure (if ther is no backup (namely CDN))
* Audit policy is way too general which would result in huge overhead
* Terraform is limited to Hetzner
* Communication is over public network (Encrypted but still vulnerable to Zero-day exploits since its observable) 
  * Firewall policies minimize the observable scope
* Since updating procedure on k8s is differnt from version to version, currently, only update form V1.25 to 1.26 is supported



## Work flow
* Run the following command for terraform to install dependencies and create the lock file
``` bash
terraform init
```
![image](https://thebattleofisengard.s3.ir-thr-at1.arvanstorage.ir/terraform_init.gif)


* Run the following command and check if there are any problems with terraform
``` bash
terraform plan
```
![image](https://thebattleofisengard.s3.ir-thr-at1.arvanstorage.ir/terraform_plan.gif)

* Apply terraform modules and get started
``` bash
terraform apply

```
![image](https://thebattleofisengard.s3.ir-thr-at1.arvanstorage.ir/terraform_apply1.gif)

> **Note**
> Add haproxy ip as the A record for control plain record
> Add worker IP addreses for Grafana, Prometheus and kibana

* Check if Prometheus works
* > **Note**
> Check if all metrics are exposed properly
![image](https://thebattleofisengard.s3.ir-thr-at1.arvanstorage.ir/Prometheus_works.gif)


* Check if Grafana works
* > **Note**
> All dashboard are provisioned in config map
> To add custom dashbaord on load, add it to dashbaord as a .json file. It would automatically be loaded to Grafana
> 
> 
![image](https://thebattleofisengard.s3.ir-thr-at1.arvanstorage.ir/grafana_works.gif)


* Check if Elasticsearch is green
``` bash
kubectl get elasticsearch -n elastic-system
```
![image](https://thebattleofisengard.s3.ir-thr-at1.arvanstorage.ir/elasticsearch_green.gif)


* Check if Kibana works

![image](https://thebattleofisengard.s3.ir-thr-at1.arvanstorage.ir/kibana_works.gif)



* Check if fluentbit works

![image](https://thebattleofisengard.s3.ir-thr-at1.arvanstorage.ir/Fluentbit_Works.gif)



* To Clean up everything (including server)
``` bash
terraform destroy
```
![image](https://thebattleofisengard.s3.ir-thr-at1.arvanstorage.ir/terraform_destroy.gif)

