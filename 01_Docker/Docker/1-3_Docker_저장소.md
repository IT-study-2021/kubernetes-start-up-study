# 1.3 Docker 저장소

Docker Hub는 도커 이미지 원격 저장소 (깃허브랑 비슷)

## 1. Image tag 달기

```bash
$ docker tag [OLD_NAME]:[TAG] [NEW_NAME]:[TAG]

# 예시
$ docker tag nginx:latet <USER_NAME>/nginx:1
```

## 2. Image 확인

- sieun/nginx 와 nginx 의 Image 는 같음. 사실상 같은 이미지이다

```bash
$ docker images

# 실행 결과
REPOSITORY          TAG       IMAGE ID       CREATED        SIZE
sieun/nginx         1         d1a364dc548d   3 days ago     133MB
nginx               latest    d1a364dc548d   3 days ago     133MB
ubuntu              16.04     9ff95a467e45   9 days ago     135MB
ubuntu              latest    7e0aa2d69a15   5 weeks ago    72.7MB
hello-world         latest    d1165f221234   2 months ago   13.3kB
algo                0.1       9ce251372298   3 months ago   1.2GB
docker101tutorial   latest    026b4a3265d7   3 months ago   27.9MB
alpine/git          latest    04dbb58d2cea   4 months ago   25.1MB
docker/whalesay     latest    6b362a9f73eb   6 years ago    247MB
```

## 3. Docker Hub login

```bash
$ docker login

# 실행 결과 (ID/PW 입력)
Authenticating with existing credentials...
Login Succeeded
```

## 4. Image 업로드

```bash
$ docker push <USERNAME>/<NAME>
$ docker push sieun/nginx
```

## 5. Image 다운로드

- run 명령을 사용하면 다운로드 + 실행까지 할 수 있지만, pull 할 경우 이미지만 다운로드

```bash
$ docker pull redis
```

## 6. Image 삭제

- 로컬 서버에 존재하는 이미지 삭제. 원격 저장소에는 남아있어서 다시 pull 가능

```bash
$ docker rmi <IMAGE_NAME>
```