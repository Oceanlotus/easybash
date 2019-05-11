#一键rancher部署！仅限centos7
 yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
 yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
 yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io	
service docker start
docker run -d --restart=unless-stopped  -v /opt/rancher:/var/lib/rancher -p 80:80 -p 443:443 rancher/rancher:latest