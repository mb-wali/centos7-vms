# Playbooks
Ansible playbooks are blueprint of automation tasks.

## Writing a Playbook
if you run this playbook it will install **nano** in all the servers.
```yml
---
- hosts: all # which host
  become: true # become the default `sudo`
  tasks:
  - name: install nano package  # task title
    yum:    # module we want to use
      name: nano    # name of the package
      state: latest # (optional): install or update the existing to latest
```
**States for module**
* **state: latest**: will update the specified package if it's not of the latest available version.
* **state: absent**:  will remove the specified package.
* **state: present**: will simply ensure that a desired package is installed.
* **state: installed**: will simply ensure that a desired package is installed.
* **state: removed**: will remove the specified package.

**Tasks**
* **pre_task**: These tasks needs to run before anyother tasks
* **post_task**: These tasks needs to run after other tasks.

### The 'when' Conditional
Run a playbook on certain conditions.
This will run only if the OS is CentOS.
we can basically use anykind of variables.
```yml
---
- hosts: all
  ....
    yum:
      name: nano
    when: ansible_distribution == "CentOS" # run only to CentOS OS
```

**if you want to check against multiple distributions:**
```yml
---
- hosts: all
  ....
    apt:
      name: nano
    when: ansible_distribution in ["Ubuntu", "Debian"] # run only on defined value for OS
```

**if you want to use multiple variables**
```yml
---
- hosts: all
  ....
    yum:
      name: nano
    when: ansible_distribution == "CentOS" and ansible_distribution_version == "7"
```

### (TODO:)Variables
in ansible variable are inside `{}`.
* **"{string_variable}"** string varibles are always in double qoutes.
declaring ??

### Package module
package module is a generic package manager, whatever package manager the underline host or target server uses.
its practical to use if the package name is not different in operating systems.
```yml
---
- hosts: all 
  become: true
  tasks:
  - name: install nano package
    package:    # generic package manager
      name: nano
```

### Tags
Use `tags` to add some metadata to our plays, that makes our testing playbook easier to run.
**tags: always** this will run always.

```yml
---
- hosts: all
  become: true
  pre_tasks: # run this first
  - name: install nano package
    tags: centos, editor # run only if these tags are specified
    yum:
      name: nano
      state: latest
```
**list avalible tags in a playbook**
```bash
ansible-playbook --list-tags playbook.yml
```

**run the playbook with tags**
```bash
ansible-playbook --tags tagname playbook.yml
```

### Managing Files
use ansible to copy files to the servers.

**create a play to copy a file, using copy module**
```yml
---
- hosts: webservers
  become: true
  tasks: 
  - name: copy default html template
    copy:
      src: ./path/file # path to your file in ansible controller
      dest: /var/www/html/file # path to your server
      owner: root
      group: root
      mode: 0644  # permission
```

### Managing Services
Managing services in servers such as docker, httpd and so on.
**service** module allow us to manage services in our linux machines.
```yml
---
- hosts: all
  become: true
  tasks:
  - name: install httpd package
    yum:
      name: httpd
  # after installing we need to start it
  - name: start httpd service
    service:
      name: httpd
      state: started # start the service
      enabled: yes # enable the service
```



### Change a line in a file
**lineinfile** module allow you to change a line of code in a file.
```yml
---
- hosts: mail 
  become: true
  tasks:
  - name: change e-mail address for admin
    lineinfile: # this module allow you to change the line
      path: /etc/path/filename.extention # path to the file
      regexp: '^ServerAdmin' # regular expression - the beginning of the line
      line: ServerAdmin new_email@example.com # change to this
    register: httpd # this module allows ansible to capture a state in to a variable # httpd is the variable name

  - name: restart httpd
    service:
      name: httpd
      state: restarted  # restart the service
    when: httpd.changed # using the register module variable, run when that change has happend.
```

### Ansible User Management
**user** module is used for creating a user that will run our tasks.

Creating a user:
```yml
---
- hosts: all
  become: true
  tasks:
  - name: create user
    user:
      name: simone # name of the user
      groups: root # adding this user to root group
```

**configure this user to run ansible jobs**
&
**authorized_key** module is meant to do this job.

Adding ssh-key for this user:
```yml
---
- hosts: all
  become: true
  tasks:
  - name: add ssh key for simone
    authorized_key:
      user: simone # name of the user
      key: "<past the public ssh key>"
```

**add sudoers file for simone**
this will allow the user simone to run commands with sudo.
```yml
---
- hosts: all
  become: true
  tasks:
  - name: add sudoers file for simone
    copy:
      src: /path/file # content of the file = # simone ALL=(ALL) NOPASSWD: ALL
      dest: /etc/sudoers.d/simone # path to the servers
      owner: root
      group: root
```

to access the server with this created user type:
```bash
ssh simone@127.10.14.125
```

#### change ansible config to use simone user
**ansible.cfg**
```cfg
[defaults]
remote_user = simone
```

## Roles
Roles let you automatically load related vars, files, tasks, handlers, and other Ansible artifacts based on a known file structure.

```yml
---
- hosts: all
  become: true
  roles:
    - nano
```

**Creating roles,** 
* We need a new directory called `roles`.
* Inside this directory make a directory for each roles. e.g. `roles/nano`.
* And then we will create a task directory, e.g. `roles/nano/tasks`.
inside our tasks directory we will put our playbooks or also called `task_books`.
* create main.yml e.g. `roles/nano/tasks/main.yml` - which is a **task book** meaning it contains only tasks.
  ```yml
  ---
  - name: install nano package
    yum:
      name: nano
      state: latest
  ```

**Using roles**


https://www.youtube.com/watch?v=tq9sCeQNVYc&list=PLT98CRl2KxKEUHie1m24-wkyHpEsa4Y70&index=14

## Available Plabooks

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

keep in mind this playbook might take a while.
```shell
ansible-playbook ./playbooks/k8s/k8s-master.yml
```

* initialize K8S cluster
    * --ignore-preflight-errors=all # Ignore preflight errors
    * --api-server-advertise='masternodeip'
    * --pod-network-cidr='network.subnet'
* create `.kube` directory
* copy admin.conf
* install flannel

https://www.youtube.com/watch?v=SrhmT-zzoeA&t=925s @ 22:26



https://www.digitalocean.com/community/tutorials/how-to-create-a-kubernetes-cluster-using-kubeadm-on-centos-7