# centos7-ansible
Ansible controller for https://github.com/mb-wali/centos7-vms

## Build
```bash
docker build -t mbwali/centos7-ansible:latest .
```

## Run Docker in Docker Using dind
For more on run [Docker in Docker](https://devopscube.com/run-docker-in-docker/)
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
