#!bin/sh
# coding: utf-8 


# script to run on debian 8

# Update and upgrade OS
apt update 
apt upgrade 

# Install admin tools and sofwares
apt install -y \
    sudo
    curl \
    nmap
    netstat \
    iptables \
    fail2ban \
    rkhunter \
    dstat \
    logwatch \
    whowatch \
    htop \
    vim \
    nginx \
    zsh


# Create account for sacha 
adduser sacha
adduser olive sudo
adduser sacha sudo


# Install oh-my-zsh for root, olivier and sacha
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
chsh -s /bin/zsh


# Init firewall Iptables


# Configure ssh


# Install docker engine and compose
apt update
apt purge lxc-docker*
apt install apt-transport-https ca-certificates
pt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
===========> TODO : cp -f ./docker.list /etc/apt/sources.list.d/docker.list
apt update
apt-cache policy docker-engine
apt install docker-engine
/etc/init.d/docker start
groupadd docker
apt-get upgrade docker-engine

curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


# Install dock : owncloud
adduser nextcloud
id -u nextcloud | awk '{system("sed -e ''s/__uid__/"$1"/g'' docker.cloud > docker.cloud_1")}' && mv docker.cloud_1 docker.cloud
id -g nextcloud | awk '{system("sed -e ''s/__gid__/"$1"/g'' docker.cloud > docker.cloud_1")}' && mv docker.cloud_1 docker.cloud
mkdir -p /docker/nextcloud
mkdir -p /mnt/nextcloud/data
mkdir -p /mnt/nextcloud/config
mkdir -p /mnt/nextcloud/apps
mkdir -p /mnt/nextcloud/db
chown nextcloud:nextcloud /mnt/nextcloud/ -R
mv docker.cloud /docker/nextcloud/docker-compose.yml
chown nextcloud:nextcloud /docker/nextcloud/docker-compose.yml
old_dir=`pwd`
cd /docker/nextcloud
docker-compose up -d
cd $old_dir


# Install dock : gitlab



# Install dock : AbsG 3 & 4


# Install sendsms



# Configure nginx 



# Configure backup



# Clean cache
rm -rf /var/lib/apt/lists/*


# Bye !

# Some usefull command

# Clean Docker container & images :
# docker ps -a | awk 'FNR > 1 {system("docker rm "$1)}'
# docker images | awk 'FNR > 1 {system("docker rmi -f "$3)}'
