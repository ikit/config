#!bin/sh
# coding: utf-8 


# =====================================
# TODO Test if operating system is debian. otherwise : abord



# =====================================
# Passwords that will be used by servers 
# - all password that are set with "pwd" value will be generated automaticaly via random.org.
# - you can put your own passwords if you want. You just need to replace "pwd" by your own values

PWD_DOCKER_CLOUD_MYSQL_ROOT="pwd"
PWD_DOCKER_CLOUD_MYSQL_USER="pwd"
PWD_DOCKER_GIT_POSTGRES_ROOT="pwd"
PWD_DOCKER_GIT_POSTGRES_USER="pwd"
PWD_DOCKER_ABSG_MYSQL_ROOT="pwd"
PWD_DOCKER_ABSG_MYSQL_USER="pwd"

curl "https://www.random.org/passwords/?num=10&len=15&format=plain" > pwds

if [ $PWD_DOCKER_CLOUD_MYSQL_ROOT = "pwd" ]; then
	PWD_DOCKER_CLOUD_MYSQL_ROOT=`sed '1q;d' pwds`
fi
if [ $PWD_DOCKER_CLOUD_MYSQL_USER = "pwd" ]; then
	PWD_DOCKER_CLOUD_MYSQL_USER=`sed '2q;d' pwds`
fi

if [ $PWD_DOCKER_GIT_POSTGRES_ROOT = "pwd" ]; then
	PWD_DOCKER_GIT_POSTGRES_ROOT=`sed '3q;d' pwds`
fi
if [ $PWD_DOCKER_GIT_POSTGRES_USER = "pwd" ]; then
	PWD_DOCKER_GIT_POSTGRES_USER=`sed '4q;d' pwds`
fi

if [ $PWD_DOCKER_ABSG_MYSQL_ROOT = "pwd" ]; then
	PWD_DOCKER_ABSG_MYSQL_ROOT=`sed '5q;d' pwds`
fi
if [ $PWD_DOCKER_ABSG_MYSQL_ROOT = "pwd" ]; then
	PWD_DOCKER_ABSG_MYSQL_ROOT=`sed '6q;d' pwds`
fi




# =====================================
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


# =====================================
# Create account for sacha 
adduser sacha
adduser olive sudo
adduser sacha sudo


# =====================================
# Install oh-my-zsh for root, olivier and sacha
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
chsh -s /bin/zsh


# =====================================
# Init firewall Iptables


# =====================================
# Configure ssh


# =====================================
# Install docker engine and compose
apt update
apt purge lxc-docker*
apt install -y apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
mv -f ./docker.list /etc/apt/sources.list.d/docker.list
apt update
apt-cache policy docker-engine
apt install -y docker-engine
/etc/init.d/docker start
groupadd docker
apt-get upgrade docker-engine

curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


# =====================================
# Install dock : owncloud
adduser nextcloud
sed -i 's/__uid__/'$(id -u nextcloud)'/g' docker.cloud
sed -i 's/__gid__/'$(id -g nextcloud)'/g' docker.cloud
sed -i 's/__root_pwd__/'$PWD_DOCKER_CLOUD_MYSQL_ROOT'/g' docker.cloud
sed -i 's/__nextcloud_pwd__/'$PWD_DOCKER_CLOUD_MYSQL_USER'/g' docker.cloud
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


# =====================================
# Install dock : gitlab



# =====================================
# Install dock : AbsG 3 & 4



# =====================================
# Install sendsms



# =====================================
# Configure nginx 



# =====================================
# Configure backup



# =====================================
# Clean cache
rm -rf /var/lib/apt/lists/*


# =====================================
# Bye !

# Some usefull command

# Clean Docker container & images :
# docker ps -a | awk 'FNR > 1 {system("docker rm "$1)}'
# docker images | awk 'FNR > 1 {system("docker rmi -f "$3)}'
