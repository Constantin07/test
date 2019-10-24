FROM centos:7 AS BUILDER

ARG REPOSITORY=https://github.com/ansible/ansible.git

RUN yum -y install git make rpm-build gcc openssl-devel python2-devel epel-release which

RUN yum -y install python36 python36-devel python36-pip.noarch python2-pip.noarch python-docutils \
    python-sphinx python-jinja2 python2-cryptography python-six pytest python-requests \
    python-coverage python-mock python-boto3 python-paramiko python-jmespath python-passlib \
    python-virtualenv python2-pyyaml

RUN pip3 install --no-cache-dir straight.plugin Jinja2 PyYAML cryptography && \
    pip install --no-cache-dir packaging

RUN git clone --depth 1 --single-branch --branch devel ${REPOSITORY}

WORKDIR /ansible

RUN make rpm
