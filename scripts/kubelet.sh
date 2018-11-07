#!/usr/bin/env bash

version=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
#version=v1.12.0'

curl -LO https://storage.googleapis.com/kubernetes-release/release/${version}/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# CentOS
yum install bash-completion -y

echo "source <(kubectl completion bash)" >> ~/.bashrc
