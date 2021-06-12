#!/bin/bash

# apt에 등록 되어있는 패키지들 리스트를 업데이트한다
echo "apt update"
sudo apt update
# -y : 중간에 y/n 묻는거 전부 yes로 대답하겠다는 option
# -qq: 설치하며 verbose 하는 line을 quite mode로 설정
# docker.io, nfs-common, dnsutils, curl을 설치
echo "Installilng docker, nfs-common, dnsutils and curl"
sudo apt install -yqq docker.io nfs-common dnsutils curl

if [ -z "${MASTER_IP}"]; then
  echo "MASTER_IP need to be set"
  echo "$ export MASTER_IP=<THE_MASTER_IP_FROM_MASTER_NODE>"
  exit 255
fi

if [ -z "${NODE_TOKEN}";] then
  echo "NODE_TOKEN need to be set"
  echo "$ export NODE_TOKEN=<THE_NODE_TOKEN_FROM_MASTER_NODE>"
  exit 255
fi

# k3s 마스터 서치
curl -sfL https://get.k3s.io | K3S_URL=https://$MASTER_IP:6443 \
	K3S_TOKEN=$NODE_TOKEN \
	INSTALL_K3S_EXEC="--node-name worker --docker" \
	INSTALL_K3S_VERSION="v1.18.6+k3s1" sh -s -

echo "Install successfully finished"
echo "Now, run following commands to check your status"
echo "$ source ~/.bashrc"
echo "$ kubectl cluster-info"
echo "$ kubectl get node -o wide"
