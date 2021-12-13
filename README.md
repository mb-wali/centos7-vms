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

**access one of the VMS**

```shell
docker exec -it <containerid> bash
```

**now try logging into the machine, with:**

```shell
ssh root@nodethree.example.com
ssh root@nodeone.example.com
ssh root@nodetwo.example.com
```


## Build
```bash
docker build -t mbwali/centos7-vms:latest ./centos
```
