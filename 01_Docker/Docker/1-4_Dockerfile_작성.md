# 1.4 Dockerfile 작성

## 1. Dockerfile이란?

- 도커 이미지를 생성하기 위해서는 Dockerfile 이라는 텍스트 문서를 작성해야 한다.
사용자는 Dockerfile에 특정 명령을 기술하여 원하는 도커 이미지를 생성한다.
    - Dockerfile에 base image 지정
    - 원하는 소프트웨어 및 라이브러리를 설치하기 위한 명렁 기술
    - 컨테이너 실행 시 수행할 명령 기술

## 2. Dockerfile 기초

아래와 같이 파이썬 스크립트와 도커 파일을 만들어보자

```python
#hello.py
import os
import sys

my_ver = os.environ["my_ver"]
arg = sys.argv[1]

print("hello %s, my version is %s!" % (arg, my_ver))
```

```docker
#Dockerfile
FROM ubuntu:18.04

RUN apt-get update \
		&& apt-get install -y \
			curl \
			python-dev

WORKDIR /root
COPY hello.py .
ENV my_ver 1.0

CMD ["python", "hello.py", "guest"]
```

- FROM: base image를 나타냄. 해당 이미지를 기반으로 새로운 도커 이미지 생성
- RUN: 사용자가 지정한 명령 실행
- WORKDIR: 이미지의 작업 폴더 지정. 예제에서는 root 폴더 사용
- COPY: 로컬 호스트에 존재하는 파일을 이미지 안으로 복사
- ENV: 이미지의 환경변수 지정
- CMD: 이미지 실행 시 default로  실행되는 명령 지정

## 3. Dockerfile 빌드

```bash
docker build [PATH] -t [IMAGE_NAME]:[TAG]
```

- [PATH]: Dockerfile이 위치한 디렉터리 (현재 위치는 . 으로 사용)
- 예시

```bash
$ docker build . -t hello:1

[+] Building 40.1s (10/10) FINISHED                                                                                                                                                                                                           
 => [internal] load build definition from Dockerfile                                                                                                                                                                                     0.0s
 => => transferring dockerfile: 229B                                                                                                                                                                                                     0.0s
 => [internal] load .dockerignore                                                                                                                                                                                                        0.0s
 => => transferring context: 2B                                                                                                                                                                                                          0.0s
 => [internal] load metadata for docker.io/library/ubuntu:18.04                                                                                                                                                                          7.6s
 => [auth] library/ubuntu:pull token for registry-1.docker.io                                                                                                                                                                            0.0s
 => [internal] load build context                                                                                                                                                                                                        0.0s
 => => transferring context: 171B                                                                                                                                                                                                        0.0s
 => [1/4] FROM docker.io/library/ubuntu:18.04@sha256:67b730ece0d34429b455c08124ffd444f021b81e06fa2d9cd0adaf0d0b875182                                                                                                                    3.5s
 => => resolve docker.io/library/ubuntu:18.04@sha256:67b730ece0d34429b455c08124ffd444f021b81e06fa2d9cd0adaf0d0b875182                                                                                                                    0.0s
 => => sha256:67b730ece0d34429b455c08124ffd444f021b81e06fa2d9cd0adaf0d0b875182 1.41kB / 1.41kB                                                                                                                                           0.0s
 => => sha256:ceed028aae0eac7db9dd33bd89c14d5a9991d73443b0de24ba0db250f47491d2 943B / 943B                                                                                                                                               0.0s
 => => sha256:81bcf752ac3dc8a12d54908ecdfe98a857c84285e5d50bed1d10f9812377abd6 3.32kB / 3.32kB                                                                                                                                           0.0s
 => => sha256:4bbfd2c87b7524455f144a03bf387c88b6d4200e5e0df9139a9d5e79110f89ca 26.70MB / 26.70MB                                                                                                                                         2.0s
 => => sha256:d2e110be24e168b42c1a2ddbc4a476a217b73cccdba69cdcb212b812a88f5726 857B / 857B                                                                                                                                               1.5s
 => => sha256:889a7173dcfeb409f9d88054a97ab2445f5a799a823f719a5573365ee3662b6f 189B / 189B                                                                                                                                               0.6s
 => => extracting sha256:4bbfd2c87b7524455f144a03bf387c88b6d4200e5e0df9139a9d5e79110f89ca                                                                                                                                                1.2s
 => => extracting sha256:d2e110be24e168b42c1a2ddbc4a476a217b73cccdba69cdcb212b812a88f5726                                                                                                                                                0.0s
 => => extracting sha256:889a7173dcfeb409f9d88054a97ab2445f5a799a823f719a5573365ee3662b6f                                                                                                                                                0.0s
 => [2/4] RUN apt-get update   && apt-get install -y    curl    python-dev                                                                                                                                                              27.8s
 => [3/4] WORKDIR /root                                                                                                                                                                                                                  0.0s 
 => [4/4] COPY hello.py .                                                                                                                                                                                                                0.0s 
 => exporting to image                                                                                                                                                                                                                   1.0s 
 => => exporting layers                                                                                                                                                                                                                  1.0s 
 => => writing image sha256:730458ae93bd8900a685d700772e93c10f348b647b53187a7d602860289745f5                                                                                                                                             0.0s 
 => => naming to docker.io/library/hello:1                                                                                                                                                                                               0.0s 

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them

#아래와 같이 이미지 생성된 것 확인
$ docker images
REPOSITORY          TAG       IMAGE ID       CREATED        SIZE
hello               1         9bffed3d7b67   34 hours ago   63.5MB
```

- 완성한 도커 이미지 실행

```bash
$ docker run hello:1
hello guest, my version is 1.0!

$ docker run hello:1 cat hello.py
#hello.py
import os
import sys

my_ver = os.environ["my_ver"]
arg = sys.argv[1]

print("hello %s, my version is %s!" % (arg, my_ver))

$ docker run hello:1 echo "hello world"
hello world

$ docker run hello:1 pwd
/root
```

## 4. Dockerfile 심화

### ARG

- Dockerfile 안에서 사용할 수 있는 매개변수 정의
- 파라미터로 넘겨지는 변수의 값에 따라 생성되는 이미지 내용 변경 가능

```docker
#Dockerfile
FROM ubuntu:18.04

RUN apt-get update \
                && apt-get install -y \
                        curl \
                        python-dev

ARG my_ver=1.0

WORKDIR /root
COPY hello.py .
ENV my_ver $my_ver

CMD ["python", "hello.py", "guest"]                                                                                                                                                                                                                                        
```

- ARG 지시자를 사용하여 my_ver 이라는 변수 생성
이미지 빌드 시, —build-arg 옵션을 이용하여 ARG 값을 덮어 씌울 수 있다.
- 실행 결과

```bash
# 다음예제에서는 ARG의 기본 값 1.0 이 아닌 2.0이 설정된다.
$ docker build . -t hello:2 --build-arg my_ver=2.0
[+] Building 1.8s (9/9) FINISHED                                                                                                                                                                                                              
 => [internal] load build definition from Dockerfile                                                                                                                                                                                     0.0s
 => => transferring dockerfile: 249B                                                                                                                                                                                                     0.0s
 => [internal] load .dockerignore                                                                                                                                                                                                        0.0s
 => => transferring context: 2B                                                                                                                                                                                                          0.0s
 => [internal] load metadata for docker.io/library/ubuntu:18.04                                                                                                                                                                          1.7s
 => [1/4] FROM docker.io/library/ubuntu:18.04@sha256:67b730ece0d34429b455c08124ffd444f021b81e06fa2d9cd0adaf0d0b875182                                                                                                                    0.0s
 => [internal] load build context                                                                                                                                                                                                        0.0s
 => => transferring context: 30B                                                                                                                                                                                                         0.0s
 => CACHED [2/4] RUN apt-get update   && apt-get install -y    curl    python-dev                                                                                                                                                        0.0s
 => CACHED [3/4] WORKDIR /root                                                                                                                                                                                                           0.0s
 => CACHED [4/4] COPY hello.py .                                                                                                                                                                                                         0.0s
 => exporting to image                                                                                                                                                                                                                   0.0s
 => => exporting layers                                                                                                                                                                                                                  0.0s
 => => writing image sha256:15be30b6166fe53eb4b7ebf4be5bbfd2cfdbb7db25e712c673c8eac7ab7ed8a5                                                                                                                                             0.0s
 => => naming to docker.io/library/hello:2

$ docker run hello:2
hello guest, my version is 2.0!

# 컨테이너 실행 시점에서 환경변수를 설정할 수 있다.
$ docker run -e my_ver=2.5 hello:2
hello guest, my version is 2.5!
```

### ENTRYPOINT

- CMD와 유사하나 실행 명령이 override 되지 않고 실행 가능한 이미지를 만든다.
- 예제1

```docker
#Dockerfile
FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y \
	    curl \
      python-dev

WORKDIR /root
COPY hello.py .
ENV my_ver 1.0

ENTRYPOINT ["python", "hello.py", "guest"]   
```

- 예제 1 실행 결과

```bash
$ docker build . -t hello:3
[+] Building 5.0s (10/10) FINISHED                                                                                                                                                                                                            
 => [internal] load build definition from Dockerfile                                                                                                                                                                                     0.0s
 => => transferring dockerfile: 236B                                                                                                                                                                                                     0.0s
 => [internal] load .dockerignore                                                                                                                                                                                                        0.0s
 => => transferring context: 2B                                                                                                                                                                                                          0.0s
 => [internal] load metadata for docker.io/library/ubuntu:18.04                                                                                                                                                                          4.8s
 => [auth] library/ubuntu:pull token for registry-1.docker.io                                                                                                                                                                            0.0s
 => [internal] load build context                                                                                                                                                                                                        0.0s
 => => transferring context: 30B                                                                                                                                                                                                         0.0s
 => [1/4] FROM docker.io/library/ubuntu:18.04@sha256:67b730ece0d34429b455c08124ffd444f021b81e06fa2d9cd0adaf0d0b875182                                                                                                                    0.0s
 => CACHED [2/4] RUN apt-get update   && apt-get install -y    curl    python-dev                                                                                                                                                        0.0s
 => CACHED [3/4] WORKDIR /root                                                                                                                                                                                                           0.0s
 => CACHED [4/4] COPY hello.py .                                                                                                                                                                                                         0.0s
 => exporting to image                                                                                                                                                                                                                   0.0s
 => => exporting layers                                                                                                                                                                                                                  0.0s
 => => writing image sha256:6d80a1f790119d69cd915913a5a07cb08e43e1928f2223d876a24554a0988956                                                                                                                                             0.0s
 => => naming to docker.io/library/hello:3                                                                                                                                                                                               0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them

$ docker run hello:3
hello guest, my version is 1.0!

# echo "hello" 를 파라미터로 전달하더라도 실행 명령이 override 되지는 않는다.
$ docker run hello:3 echo "hello"
hello guest, my version is 1.0!
```

- 예제 2

```docker
#Dockerfile
FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y \
	    curl \
      python-dev

WORKDIR /root
COPY hello.py .
ENV my_ver 1.0

ENTRYPOINT ["python", "hello.py"]   #guest 삭제
```

- 예제 2 실행 결과

```bash
$ docker build . -t hello:4
[+] Building 3.8s (10/10) FINISHED                                                                                                                                                                                                            
 => [internal] load build definition from Dockerfile                                                                                                                                                                                     0.0s
 => => transferring dockerfile: 227B                                                                                                                                                                                                     0.0s
 => [internal] load .dockerignore                                                                                                                                                                                                        0.0s
 => => transferring context: 2B                                                                                                                                                                                                          0.0s
 => [internal] load metadata for docker.io/library/ubuntu:18.04                                                                                                                                                                          3.7s
 => [auth] library/ubuntu:pull token for registry-1.docker.io                                                                                                                                                                            0.0s
 => [1/4] FROM docker.io/library/ubuntu:18.04@sha256:67b730ece0d34429b455c08124ffd444f021b81e06fa2d9cd0adaf0d0b875182                                                                                                                    0.0s
 => [internal] load build context                                                                                                                                                                                                        0.0s
 => => transferring context: 30B                                                                                                                                                                                                         0.0s
 => CACHED [2/4] RUN apt-get update   && apt-get install -y    curl    python-dev                                                                                                                                                        0.0s
 => CACHED [3/4] WORKDIR /root                                                                                                                                                                                                           0.0s
 => CACHED [4/4] COPY hello.py .                                                                                                                                                                                                         0.0s
 => exporting to image                                                                                                                                                                                                                   0.0s
 => => exporting layers                                                                                                                                                                                                                  0.0s
 => => writing image sha256:aa98cb29097285a916c579ac6c3eecd9411e2d24220f3cd25c8eb1ea4ee23c48                                                                                                                                             0.0s
 => => naming to docker.io/library/hello:4                                                                                                                                                                                               0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them

# new-guest가 실행 명령으로 override 되지 않고 그대로 python hello.py 파라미터로 전달된다.
$ docker run hello:4 new-guest
hello new-guest, my version is 1.0!
```

### CMD와 ENTRYPOINT 차이점

- CMD는 default command. 사용자아 이미지를 실행할 때 별다른 명령을 파라미터로 넘겨주지 않으면 default로 실행되는 명령어며, 언제든지 override 할 수 있다.
- ENTRYPOINT는 이미지를 실행 가능한 바이너리로 만들어주는 지시자. 이미지 실행 시, 무조건 호출되고 파라미터를 전달하게 되면 해당 파라미터가 그대로 ENTRYPOINT 파라미터로 전달된다.