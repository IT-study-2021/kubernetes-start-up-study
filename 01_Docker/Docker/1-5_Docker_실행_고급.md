# 1.5 Docker 실행 고급

## 1. Network

```bash
docker run -p [HOST_PORT]:[CONTAINER_PORT] [IMAGE_NAME]
```

- 외부의 트래픽을 컨테이너 내부로 전달하기 위해 로컬 호스트 서버와 컨테이너의 포트를 매핑시켜 트래픽 포워딩
- 예제: 호스트이 5000번 포트를 컨테이너의 80 포트와 매핑하는 명령

```bash
$ docker run -p 5000:80 -d nginx
e17efeace22a16940bf042c88082e7bfc5c2b0bbf8a30dad6b380de90777aae2

$ curl localhost:5000
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

## 2. Volume

```bash
docker run -v [HOST_DIR]:[CONTAINER_DIR] [IMAGE_NAME]
```

- 컨테이너는 휘발성 프로세스이므로, 컨테이너 내부의 데이터를 영구적으로 저장할 수 없다
- 컨테이너의 데이터를 지속적으로 보관하기 위해서 볼륨을 사용한다.
- 컨테이너 실행 시, 로컬 호스트의 파일 시스템을 컨테이너와 연결하여 필요한 데이터를 로컬 호스트에 저장할 수 있다. (volumn mount)

```bash
$ docker run -p 6000:80 -v $(pwd):/usr/share/nginx/html/ -d nginx
d9436f3039305bc12ca5e676637d012e2cf506b74196d003fd1493e3198bdf00

$ echo hello! >> $(pwd)/hello.txt
$ curl localhost:6000/hello.txt
hello!
```

- 변경사항이 많은 파일의 경우, 호스트 서버에 디렉터리를 연결하여 호스트 서버에서 손쉽게 파일을 수정할 수 있다.
- 또한 볼륨을 이용하여 데이터를 저장할 경우, 데이터가 휘발되지 않고 유지되는 장점이 있다.

## 3. Entrypoint

- ENTRYPOINT는 파라미터 전달 시 override 되지 않는다고 했으나, —entrypoint 옵션을 사용하여 강제로 ENTRYPOINT를 override 할 수 있다.

```docker
#Dockerfile
FROM ubuntu:18.04

ENTRYPOINT ["echo"]
```

- build

```bash
$ docker build . -t lets-echo
[+] Building 3.8s (6/6) FINISHED                                                                                                                                                                                                              
 => [internal] load build definition from Dockerfile                                                                                                                                                                                     0.0s
 => => transferring dockerfile: 94B                                                                                                                                                                                                      0.0s
 => [internal] load .dockerignore                                                                                                                                                                                                        0.0s
 => => transferring context: 2B                                                                                                                                                                                                          0.0s
 => [internal] load metadata for docker.io/library/ubuntu:18.04                                                                                                                                                                          3.7s
 => [auth] library/ubuntu:pull token for registry-1.docker.io                                                                                                                                                                            0.0s
 => CACHED [1/1] FROM docker.io/library/ubuntu:18.04@sha256:67b730ece0d34429b455c08124ffd444f021b81e06fa2d9cd0adaf0d0b875182                                                                                                             0.0s
 => exporting to image                                                                                                                                                                                                                   0.0s
 => => exporting layers                                                                                                                                                                                                                  0.0s
 => => writing image sha256:8767478b9b6d3cd9fd64f03607c7ad3e0f6fd337fa66b4c0768bb0ae13265a79                                                                                                                                             0.0s
 => => naming to docker.io/library/lets-echo                                                                                                                                                                                             0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them

$ docker run lets-echo hello
hello

# entrypoint는 기본적으로 override 되지 않음
$ docker run lets-echo cat /etc/password
cat /etc/password

# --entrypoint 로 기존 명령어 override
$ docker run --entrypoint=cat lets-echo /etc/passwd
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
_apt:x:100:65534::/nonexistent:/usr/sbin/nologin
```

## 4. User

- 기본적으로 컨테이너의 유저는 root이나, 일반 유저를 사용하도록 만들 수 있음

```docker
#Dockerfile
FROM ubuntu:18.04

#Ubuntu user 생성
RUN adduser --disabled-password --gecos "" ubuntu

#컨테이너 실행 시 ubuntu 로 실행
USER ubuntu
```

- build

```bash
$ docker build . -t my-user
$ docker run -it my-user bash

# user mode 로 접속해서 apt 명령어 실패
ubuntu@1ff3fe0d1c94:/$ apt update
Reading package lists... Done
E: List directory /var/lib/apt/lists/partial is missing. - Acquire (13: Permission denied)

ubuntu@1ff3fe0d1c94:/$ exit
exit

# docker 실행 시 --user root 사용하면 root 로 접속 가능
$ docker run --user root -it my-user bash

# 이제 apt 사용 가능
root@82bb68885130:/# apt update
Get:1 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]                             
Get:2 http://archive.ubuntu.com/ubuntu bionic InRelease [242 kB]                                        
Get:3 http://security.ubuntu.com/ubuntu bionic-security/multiverse amd64 Packages [24.7 kB]
Get:4 http://security.ubuntu.com/ubuntu bionic-security/universe amd64 Packages [1413 kB]
Get:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]        
Get:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]        
Get:7 http://security.ubuntu.com/ubuntu bionic-security/main amd64 Packages [2152 kB]
Get:8 http://archive.ubuntu.com/ubuntu bionic/multiverse amd64 Packages [186 kB]
Get:9 http://archive.ubuntu.com/ubuntu bionic/main amd64 Packages [1344 kB]
Get:10 http://security.ubuntu.com/ubuntu bionic-security/restricted amd64 Packages [423 kB]
Get:11 http://archive.ubuntu.com/ubuntu bionic/universe amd64 Packages [11.3 MB]      
Get:12 http://archive.ubuntu.com/ubuntu bionic/restricted amd64 Packages [13.5 kB]
Get:13 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 Packages [2584 kB]
Get:14 http://archive.ubuntu.com/ubuntu bionic-updates/restricted amd64 Packages [452 kB]
Get:15 http://archive.ubuntu.com/ubuntu bionic-updates/multiverse amd64 Packages [31.6 kB]
Get:16 http://archive.ubuntu.com/ubuntu bionic-updates/universe amd64 Packages [2184 kB]
Get:17 http://archive.ubuntu.com/ubuntu bionic-backports/main amd64 Packages [11.3 kB]
Get:18 http://archive.ubuntu.com/ubuntu bionic-backports/universe amd64 Packages [11.4 kB]
Fetched 22.7 MB in 6s (3557 kB/s)                                                                                                                                                                                                            
Reading package lists... Done
Building dependency tree       
Reading state information... Done
5 packages can be upgraded. Run 'apt list --upgradable' to see them.

root@82bb68885130:/# exit
```