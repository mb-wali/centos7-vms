
# ANSIBLE
using Ansible on Centos7 OS.

## install

*TODO: install when ansible container starts.*
```shell
docker exec -it ansible bash
yum install epel-release -y
yum install -y ansible
```

### ansible version
```bash
ansible --version
```

## Configure ansible hosts

1. clone this repo

```git
git clone https://github.com/mb-wali/centos7-vms.git
```

2. navigate to repo

```shell
cd centos7-vms/ansible/
```

3. modify **ansible.cfg** to point to the hosts file.

Ansible configuration file.
which overrides `/etc/ansible/ansible.cfg`

```
Inventory = /centos7-vms/ansible/hosts
```

4. Add ssh-keyscan to known_host
```shell
chmod +x ./add_ssh-keyscan.sh
./add_ssh-keyscan.sh
```

**check ansible hosts**

list only master hosts of ansible
```shell
ansible masters --list-hosts
```

list all the hosts of ansible
```shell
ansible all --list-hosts
```

ping all ansible hosts
```shell
ansible -m ping all
```

run playbook
```shell
ansible-playbook ./playbooks/k8s/<playbookname>.yml
```
