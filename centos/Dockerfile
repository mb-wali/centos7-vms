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
        iproute2 iptables net-tools
RUN yum clean -y all

# # for building kernel modules
RUN yum install -y kernel-devel kernel-headers
# RUN rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
# RUN rpm -Uvh https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
# RUN yum --enablerepo=elrepo-kernel install -y kernel-ml

# Install docker
RUN yum install -y install yum-utils device-mapper-persistent-data lvm2
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# installing specific docker version # Docker 18.06.1
# K8S - does not support latest
RUN yum install -y docker-ce-18.06.1.ce-3.el7 

# Generate keys
# this would b automaticly added to all the containers
# in order to access the VMS via ssh, we need to create & add the public sshkeys to other VMS.
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# Add root pass
RUN echo 'root:root' | chpasswd

# Modify `sshd_config`
# From: #PermitRootLogin yes
# TO  : PermitRootLogin yes
# Check: nano /etc/ssh/sshd_config
RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/#Port 22/Port 22/' /etc/ssh/sshd_config

CMD ["/usr/sbin/sshd", "-D"]
ENTRYPOINT ["/usr/sbin/init"]
