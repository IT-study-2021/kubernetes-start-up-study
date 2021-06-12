#!/bin/bash

# apt에 등록 되어있는 패키지들 리스트를 업데이트한다
echo "apt update"
sudo apt update
# -y : 중간에 y/n 묻는거 전부 yes로 대답하겠다는 option
# -qq: 설치하며 verbose 하는 line을 quite mode로 설정
# docker.io, nfs-common, dnsutils, curl을 설치
echo "Installilng docker, nfs-common, dnsutils and curl"
sudo apt install -yqq docker.io nfs-common dnsutils curl

# k3s 마스터 서치
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="\
	--disable traefik \
	--disable metrics-server \
  --node-name master --docker" \
  INSTALL_K3S_VERSION="v1.18.6+k3s1" sh -s -

# 마스터 통신을 위한 설정
mkdir ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown -R $(id -u):$(id -g) ~/.kube
echo "export KUBECONFIG=~/.kube/config" >> ~/.bashrc

echo "Install successfully finished"
echo "Now, run following commands to check your status"
echo "$ source ~/.bashrc"
echo "$ kubectl cluster-info"
echo "$ kubectl get node -o wide"
