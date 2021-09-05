# used to copy ssh folder from vms
# to be able to access the vms passwordless
FROM mbwali/ansible-controller:latest AS builder

FROM centos:7

# install needed packages
RUN yum install -y \
        update \
        openssh openssh-server openssh-clients \
        python \
        ca-certificates \
        nano \
        initscripts \
        git \
        iptables-devel \
        gcc \
        make \
        iproute2 iptables net-tools \
        module-init-tools \
        epel-release \
        repolist 
RUN yum clean -y all

# install dpkg
RUN yum install -y dpkg-devel dpkg-dev

# Install docker
RUN yum install -y install yum-utils device-mapper-persistent-data lvm2
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# installing specific docker version # Docker 18.06.1
# K8S - does not support latest
RUN yum install -y docker-ce-18.06.1.ce-3.el7 

# Add root pass
RUN echo 'root:root' | chpasswd

# Modify `sshd_config`
# From: #PermitRootLogin yes
# TO  : PermitRootLogin yes
# Check: nano /etc/ssh/sshd_config
RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/#Port 22/Port 22/' /etc/ssh/sshd_config

# copy .ssh folder from vms
COPY --from=builder /root/.ssh/* /root/.ssh/

CMD ["/usr/sbin/sshd", "-D"]
ENTRYPOINT ["/usr/sbin/init"]
