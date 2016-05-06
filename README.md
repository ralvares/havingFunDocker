# Dockerfile -> Build a standalone image: RHEL7 + Software_Collections + Nginx + php_fpm
Script perl: create a systemd service to manage a docker container.

HowTo install:

```
mkdir /deploy
mkdir /opt/php-farm
cp -rf nginx-proxy.service nginx.tmpl sync-php.pl template.service /opt/php-farm/
ln -s /opt/php-farm/sync-php.pl /usr/bin/sync-php
```

## Creating nginx-proxy systemd service.
```
cp -rf /opt/php-farm/nginx-proxy.service /usr/lib/systemd/system/nginx-proxy.service
systemctl enable /usr/lib/systemd/system/nginx-proxy.service
systemctl start nginx-proxy
```
##Creating a docker image using rhel7 base.
```
cd Dockerbuild-PHP
docker build --rm -t standalone_php .
```

##Demo
```
echo "127.0.0.1 	demo.com" >> /etc/hosts
mkdir /deploy/demo.com
echo "<?phpinfo();?> > /deploy/demo.com/index.php"
/usr/bin/sync-php
```

---------
```
Failed to get unit file state for CUSTOMER@demo.com.service: No such file or directory
Criando o servico -> demo.com ...
Created symlink from /etc/systemd/system/multi-user.target.wants/CUSTOMER@demo.com.service to /usr/lib/systemd/system/CUSTOMER@demo.com.service.
Domain demo.com -> [OK]
```
--------

##Testing 
```
curl http://demo.com/index.php
```

Now is possible to automate the php applications using this solution and manager your apps using systemd commands, for example:
```
systemctl status CUSTOMER@demo.com 
systemctl stop CUSTOMER@demo.com
```

To remove an application just delete the /deploy/demo.com and execute /usr/bin/sync-php.

---------
```
Application demo.com not found, removing systemd services.
Removed symlink /etc/systemd/system/multi-user.target.wants/CUSTOMER@demo.com.service.
