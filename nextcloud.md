
```
# create a container
lxc launch images:ubuntu/xenial nextcloud
# configure it
lxc exec nextcloud -- /bin/bash
# create directory in the container
mkdir -p /nextcloud/{html,config,custom_apps,data,db}

apt install wget unzip nano curl --fix-missing

# Download sources
wget https://download.nextcloud.com/server/releases/nextcloud-12.0.4.zip
# Verrify package
wget https://download.nextcloud.com/server/releases/nextcloud-12.0.4.zip.md5
wget https://download.nextcloud.com/server/releases/nextcloud-12.0.4.zip.asc
wget https://nextcloud.com/nextcloud.asc
md5sum  -c nextcloud-12.0.4.zip.md5 < nextcloud-12.0.4.zip
gpg --import nextcloud.asc
gpg --verify nextcloud-12.0.4.zip.asc nextcloud-12.0.4.zip

# Deploy sources
cd /nextcloud
unzip ~/nextcloud-12.0.4.zip
mv nextcloud/ v12.0.4
cd v12.0.4
# Installing according to [official doc](https://docs.nextcloud.com/server/12/admin_manual/installation/source_installation.html)
apt install apache2 mariadb-server libapache2-mod-php7.0 --fix-missing
apt install php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring --fix-missing
apt install php7.0-intl php7.0-mcrypt php-imagick php7.0-xml php7.0-zip --fix-missing
```
##Configuring container apache server

```
nano /etc/apache2/sites-available/nextcloud.conf
```

```
Alias / "/nextcloud/v12.0.4"

<Directory /nextcloud/v12.0.4>
  Options +FollowSymlinks
  AllowOverride All

 <IfModule mod_dav.c>
  Dav off
 </IfModule>

 SetEnv HOME /nextcloud/v12.0.4
 SetEnv HTTP_HOME /nextcloud/v12.0.4

</Directory>
```

##Create symlink to enable the nextcloud site

```
ln -s /etc/apache2/sites-available/nextcloud.conf /etc/apache2/sites-enabled/nextcloud.conf
```

##Enable apache mods

```
a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime
a2enmod setenvif
a2enmod ssl
a2ensite default-ssl
service apache2 restart
```

chown -R www-data:www-data /
mysql --user='root' --execute='CREATE DATABASE nextcloud;'
mysql --user='root' --execute="CREATE USER 'nextcloud' IDENTIFIED BY PASSWORD 'nextcloud';
mysql --user='root' --execute="GRANT ALL PRIVILEGES ON nextcloud.* TO nextcloud WITH GRANT OPTION;"
sudo -u www-data php occ  maintenance:install --database "mysql" --database-name "nextcloud"  --database-user "nextcloud" --database-pass "nextcloud" --admin-user "admin" --admin-pass "..."

# Check that nextcloud is installed
sudo -u www-data php occ status

# get list of installed modules
sudo -u www-data php occ app:list

# check
sudo -u www-data php occ app:check-code notifications













# test that server is reachable
curl 127.0.0.1:80/nextcloud




# exit from container
exit


# Get ip of the nextcloud container
lxc list
+---------------------+---------+-------------------+------+------------+-----------+
|        NAME         |  STATE  |       IPV4        | IPV6 |    TYPE    | SNAPSHOTS |
+---------------------+---------+-------------------+------+------------+-----------+
| nextcloud           | RUNNING | 10.0.4.204 (eth0) |      | PERSISTENT | 0         |
+---------------------+---------+-------------------+------+------------+-----------+
# => by example: 10.0.4.204


# config nginx on the server to redirect to the container



