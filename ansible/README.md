# ansible
Ansible controller for https://github.com/mb-wali/centos7-vms

## Build
```bash
docker build -t mbwali/centos7-ansible:latest .
```

## Run
```bash
docker run --name centos7-ansible -it -d mbwali/centos7-ansible:latest
```

## Access container
```bash
docker exec -it centos7-ansible bash 
```

## Check Ansible
```bash
ansible --version
```
