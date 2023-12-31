#! /bin/bash

sudo curl -L "https://github.com/docker/compose/releases/download/1.27.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo DOCKER_PHP_IMAGE=$1 DOCKER_DB_IMAGE=$2 docker-compose -f /home/ec2-user/Docker-Compose/docker-compose.yml up -d
