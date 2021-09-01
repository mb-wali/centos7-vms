# Playbooks
Ansible playbooks are blueprint of automation tasks.

**prerequisite.yml**
```shell
ansible-playbook ./playbooks/k8s/prerequisite.yml
```
* Start & Enable Docker - docker is pre-installed via Dockerfile


## Creating Kubernetes cluster with ansible

### Prerequisite:

1. Make an entry of each host in `etc/hosts` file for name resolution on all kubernetes nodes,
or configure it on DNS if you have DNS server.

2. Make sure kubernetes master and worker nodes are reachable between each other.
3. kubernetes doen't support "swap". Disable Swap on all nodes using below command and also make it permanent comment out the swap entry in `/etc/fstab` file.
`swapoff -a`

### Playbooks

**k8s-prerequisite.yml**
```shell
ansible-playbook ./playbooks/k8s/k8s-prerequisite.yml
```
* Disable Swap on all nodes (**Make sure swap is turn off in HOST machine** `swapoff -a`)
* Disables SELinux since it is not fully supported by Kubernetes yet.
* Sets a few netfilter-related sysctl values required for networking. This will allow Kubernetes to set iptables rules for receiving bridged IPv4 and IPv6 network traffic on the nodes.
* Adds the Kubernetes YUM repository to your remote servers’ repository lists.
* Installs kubelet and kubeadm.

The second play consists of a single task that installs kubectl on your master node.
* Restart all machines

**(WIP)k8s-master.yml** 
```shell
ansible-playbook ./playbooks/k8s/k8s-master.yml
```

* initialize K8S cluster
    * api-server-advertise=master ip address
* create `.kube` directory
* copy admin.conf
* install flannel

https://www.youtube.com/watch?v=SrhmT-zzoeA&t=925s @ 22:26



https://www.digitalocean.com/community/tutorials/how-to-create-a-kubernetes-cluster-using-kubeadm-on-centos-7