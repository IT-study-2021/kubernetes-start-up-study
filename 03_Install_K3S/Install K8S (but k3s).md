# Chap3. Install K8S (but k3s)

k3s는 IOT 및 edge computing 디바이스 위에서도 동작 할 수 있도록 만들어진 경량 쿠버네티스라고 합니다. 작고 귀여운 우리의 클러스터에 k3s를 설치해보도록 합시다~

Requirements: Ubuntu 20.04 machine 2대

## Prepare Master

### Open network port

Protocol | Port Range | Purpose
:--: | -- | :--
TCP | 6443 | API Server
TCP | 2379-2380 | etcd Server client API
TCP | 10250 | kublet API
TCP | 10251 | kube-scheduler
TCP | 10252 | kube-controller-manager
TCP | 30000-32767 | nodePort services

### Install k3s master

```bash
# apt에 등록 되어있는 패키지들 리스트를 업데이트한다
sudo apt update
# -y : 중간에 y/n 묻는거 전부 yes로 대답하겠다는 option
# docker.io, nfs-common, dnsutils, curl을 설치
sudo apt install -y docker.io nfs-common dnsutils curl

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
source ~/.bashrc

# 설치 확인
kubectl cluster-info

# Kubernetes master is running at https://127.0.0.1:6443
...

kubectl get node -o wide
...
```

여기까지 진행하면 이 instance에 k3s master가 설치되었다. 아래의 명령으로 토큰과 IP를 확인해서 worker를 설치할 때 사용하자

```bash
NODE_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
echo $NODE_TOKEN
# 나온 값을 복사하자

MASTER_IP=$(kubectl get node master -ojsonpath="{.status.addresses[0].address}")
echo $MASTER_IP
# 나온 값을 복사하자
```

## Prepare Worker

### Open Network Port

Protocol | Port Range | Purpose
:--: | -- | :--
TCP | 10250 | kublet API
TCP | 30000-32767 | nodePort services

### Install k3s worker

```bash
NODE_TOKEN=<마스터에서 확인한 토큰 입력>
MASTER_IP=<마스터에서 얻은 내부 IP 입력>

sudo apt update
sudo apt install -y docker.io nfs-common curl

# k3s worker 설치
curl -sfL https://get.k3s.io | K3S_URL=https://$MASTER_IP:6443 \
	K3S_TOKEN=$NODE_TOKEN \
	INSTALL_K3S_EXEC="--node-name worker --docker" \
	INSTALL_K3S_VERSION="v1.18.6+k3s1" sh -s -
```

실행 후 Master Node로 돌아와 아래의 명령어를 실행했을 때 MASTER와 WORKER가 모두 보이면 k8s cluster 설치가 완료된 것이다.

```bash
kubectl get node -o wide
# NAME    STATUS    ROLE    AGE    VERSION        INTERNAL-IP   ...
# master  Ready     master  10m    v1.18.6+k3s1   10.0.1.1      ...
# worker  Ready     <none>  4m     v1.18.6+k3s1   10.0.1.2      ...

```