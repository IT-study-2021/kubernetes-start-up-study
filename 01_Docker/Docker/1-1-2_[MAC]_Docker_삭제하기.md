# [MAC] Docker 삭제하기

**1. Docker for Mac에서 삭제**

- 방법 : https://docs.docker.com/docker-for-mac/

**2. Docker Toolbox로 설치가 되어있다면 터미널을 사용해서 삭제하기**

1. 삭제 스크립트 받기

$ curl -O https://raw.githubusercontent.com/docker/toolbox/master/osx/uninstall.sh

2. 다운로드 받은 파일에 실행 권한을 추가 후 실행하면 삭제가 됩니다.

$ chmod +x uninstall.sh

$ ./uninstall.sh

3. App 삭제

$rm -r /Applications/Docker.app