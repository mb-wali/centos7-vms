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
        iproute2 iptables net-tools

RUN yum clean -y all


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
