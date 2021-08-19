# Playbooks
Ansible playbooks are blueprint of automation tasks.

## Configure Kubernetes Cluster using ansible

### Prerequisities:

1. Make an entry of each host in `etc/hosts` file for name resolution on all kubernetes nodes,
or configure it on DNS if you have DNS server.

2. Make sure kubernetes master and worker nodes are reachable between each other.
3. kubernetes doen't support "swap". Disable Swap on all nodes using below command and also make it permanent comment out the swap entry in `/etc/fstab` file.
`swapoff -a`

