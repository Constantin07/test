FROM centos:7 AS BUILDER

ARG REPOSITORY=https://github.com/ansible/ansible.git

RUN yum -y install git make rpm-build gcc openssl-devel python2-devel epel-release which

RUN yum -y install python36 python36-devel python3-pip.noarch \
    python2-pip.noarch python2-docutils python2-sphinx python-jinja2 python2-pyyaml.noarch python-coverage \
    python2-cryptography python-six pytest python-requests python-mock python-boto3 python-paramiko python-jmespath python-passlib python-virtualenv

RUN pip3 install --no-cache-dir straight.plugin Jinja2 PyYAML && \
    pip install --no-cache-dir -U setuptools && \
    pip install --no-cache-dir packaging

RUN git clone --depth 1 --single-branch --branch devel ${REPOSITORY}

WORKDIR /ansible

RUN make rpm
