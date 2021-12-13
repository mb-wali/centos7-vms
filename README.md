![Build status](https://github.com/mb-wali/centos7-vms/actions/workflows/docker.yml/badge.svg)
# Centos7-vms
Centos 7 OS docker containers.

Ready orchestration of several VMS based on **Centos 7**, 
pre-configured communication between these VMS.


**docker compose orchestration**
This will run all OS of centos7 with static ip addresses
```docker
docker-compose -f docker-compose.yml up -d
```

**stop all containers**
This will stop all running containers.
```docker
docker-compose -f docker-compose.yml down
```

# Ansible controller
Ansible is an open source IT configuration management (CM) and automation platform, provided by Red Hat. It uses human-readable YAML templates so that users can program repetitive tasks to occur automatically, without learning an advanced language.

One of our container `ansible` is running on `Centos7` with Ansible installed. which is build by `/ansible-controller/Dockerfile` see also [README](/ansible-controller/README.md)

Access ansible controller machine
```bash
docker exec -it ansible bash
```

1. navigate to repo

    ```shell
    cd centos7-vms/ansible/
    ```

2. (optional): Add ssh-keyscan to known_host, this is to skip the initial connection prompt.  
    ```shell
    chmod +x ./add_ssh-keyscan.sh
    ./add_ssh-keyscan.sh
    ```

3. run a playbook
    ```shell
    ansible-playbook ./playbooks/enable-docker/enable-start-docker.yml
    ```


## Ansible commands

**ansible version**
```bash
ansible --version
```

**list [workers]**
list only workers hosts of ansible
```shell
ansible workers --list-hosts
```

**list all the hosts of ansible**
```shell
ansible all --list-hosts
```

**ping all ansible hosts**
```shell
ansible -m ping all
```

**run a playbook**
```shell
ansible-playbook ./playbooks/enable-docker/enable-start-docker.yml
```

**list all information about the servers**
```shell
ansible all -m gather_facts
```

**list all information about a single server**
```shell
ansible all -m gather_facts --limit host@domain.com
```

**run ansible with specific ssh-key and inventory**
This command will make a connection to all the servers specified in inventory, and output the status result.
```bash
ansible all --key-file ~/.ssh/ansible -i inventory -m 
```
`--key-file`- specify ssh key file that has been copied to the servers.
`-i` - inventory, file where all the server dns or ip is defined.
`-m` - module, the module that we want to run e.g. ping

## Ansible config file
**ansible.cfg**
```cfg
[defaults]

# the path should match where the hosts file is located in your machine
inventory = /path/to/file

# if set, always use this private key file for authentication, same as
# if passing --private-key to ansible or ansible-playbook
private_key_file = /path/to/file

# default user to use for playbooks if user is not specified
# (/usr/bin/ansible will use current user as default)
remote_user = root
```
