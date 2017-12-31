
```
# create a container
lxc launch images:ubuntu/xenial absg4
# configure it
lxc exec nextcloud -- /bin/bash
# create directory in the container

mkdir -p /var/www
cd /var/www

apt install wget unzip nano curl git --fix-missing
apt install apache2 mariadb-server libapache2-mod-php7.0 --fix-missing
apt install php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring php7.0-intl php7.0-mcrypt php-imagick php7.0-xml php7.0-zip --fix-missing

# Download sources
git clone https://github.com/ikit/AbsG4.git
```

## Configuring container apache server

```
nano /etc/apache2/sites-available/absg4.conf
```

```
Alias / "/var/www/AbsG4"

<Directory /var/www/AbsG4>
  Options +FollowSymlinks
  AllowOverride All

 <IfModule mod_dav.c>
  Dav off
 </IfModule>

 SetEnv HOME /var/www/AbsG4
 SetEnv HTTP_HOME /var/www/AbsG4

</Directory>
```

##Create symlink to enable the nextcloud site

```
ln -s /etc/apache2/sites-available/absg4.conf /etc/apache2/sites-enabled/absg4.conf
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

chown -R www-data:www-data /var/www
mysql --user='root' --execute='CREATE DATABASE absg;'
mysql --user='root' --execute="CREATE USER 'absg' IDENTIFIED BY 'absg';"
mysql --user='root' --execute="GRANT ALL PRIVILEGES ON absg.* TO absg WITH GRANT OPTION;"
sudo -u www-data php occ  maintenance:install --database "mysql" --database-name "nextcloud"  --database-user "nextcloud" --database-pass "nextcloud" --admin-user "admin" --admin-pass "..."

# init database
mysql absg < install/create_all.sql

# settings database (replace all keywords between <_>)
```
nano absg/config/database.php
nano absg/config/config.php
```












# test that server is reachable
curl 127.0.0.1




# exit from container
exit


# Get ip of the nextcloud container
lxc list
+---------------------+---------+-------------------+------+------------+-----------+
|        NAME         |  STATE  |       IPV4        | IPV6 |    TYPE    | SNAPSHOTS |
+---------------------+---------+-------------------+------+------------+-----------+
| absg4               | RUNNING | 10.0.4.125 (eth0) |      | PERSISTENT | 0         |
+---------------------+---------+-------------------+------+------------+-----------+
# => by example: 10.0.4.125


# config nginx on the server to redirect to the container
sudo nano /etc/nginx/sites-available/absg4

```

upstream absg4
{
    server 10.0.4.125 fail_timeout=0;
}

server
{
    listen 80;
    listen [::]:80;
    server_name dev.absolumentg.fr;

    location / {
        # Need for websockets
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_redirect off;
        proxy_buffering off;
        proxy_pass http://absg4;
    }
}
```

```
ln -s /etc/nginx/sites-available/absg4 /etc/nginx/sites-enabled/absg4
sudo ln -s /etc/nginx/sites-available/absg4 /etc/nginx/sites-enabled/absg4
sudo /etc/init.d/nginx restart
```






