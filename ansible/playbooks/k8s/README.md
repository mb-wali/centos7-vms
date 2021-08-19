# Kube

**kube-dependencies.yml**

## check playbook syntax
```shell
ansible-playbook ./playbooks/k8s/kube-dependencies.yml --syntax-check
```


## run playbook to install kubernetes and nodes 
```shell
ansible-playbook ./playbooks/k8s/kube-dependencies.yml
```

**master.yml**
In this section, you will set up the master node. Before creating any playbooks, however, it’s worth covering a few concepts such as Pods and Pod Network Plugins, since your cluster will include both.

A pod is an atomic unit that runs one or more containers. These containers share resources such as file volumes and network interfaces in common. Pods are the basic unit of scheduling in Kubernetes: all containers in a pod are guaranteed to run on the same node that the pod is scheduled on.

Each pod has its own IP address, and a pod on one node should be able to access a pod on another node using the pod’s IP. Containers on a single node can communicate easily through a local interface. Communication between pods is more complicated, however, and requires a separate networking component that can transparently route traffic from a pod on one node to a pod on another.

This functionality is provided by pod network plugins. For this cluster, you will use Flannel, a stable and performant option.
