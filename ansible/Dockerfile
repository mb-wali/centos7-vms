FROM centos:7
RUN yum clean all && \
    yum -y install nano \
    yum -y install epel-release && \
    yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip
RUN mkdir /etc/ansible/
RUN echo -e '[local]\nlocalhost' > /etc/ansible/hosts

# Upgrade Pip so cryptography package works.
RUN python -m pip install --upgrade pip==20.3.4

# install ansible
RUN pip install ansible


# clone repo
# ansible playbooks/configurations
RUN git clone https://github.com/mb-wali/centos7-vms.git

# Generate keys
# the public key is added to all the vms
# in order to access the VMS via ssh, we need to create & add the public sshkeys to other VMS.
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# give permission
RUN chmod -R 777 centos7-vms/ansible/
