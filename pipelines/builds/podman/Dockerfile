FROM centos:centos7

RUN yum install -y \
    btrfs-progs-devel \
    conmon \
    containernetworking-plugins \
    containers-common \
    crun \
    device-mapper-devel \
    git \
    glib2-devel \
    glibc-devel \
    glibc-static \
    gcc \
    golang-github-cpuguy83-md2man \
    gpgme-devel \
    iptables \
    libassuan-devel \
    libgpg-error-devel \
    libseccomp-devel \
    libselinux-devel \
    make \
    pkgconfig \
    sudo

RUN curl -sL https://go.dev/dl/go1.17.4.linux-amd64.tar.gz | tar -zx -C /usr/local
ENV PATH=$PATH:/usr/local/go/bin

RUN git clone --depth 1 --single-branch --branch v3.4.3 https://github.com/containers/podman.git
WORKDIR podman

ARG GOOS=linux
ARG GOARCH=amd64

#RUN make package
