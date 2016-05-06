#!/bin/bash
source scl_source enable nginx16
source scl_source enable httpd24
source scl_source enable rh-php56
if [ -e "/var/www/html/.apache" ]
then
 chown -R apache.apache /var/www/html
 rm -rf /opt/rh/httpd24/root/var/www/html
 ln -s /var/www/html/ /opt/rh/httpd24/root/var/www/html
 exec  /opt/rh/httpd24/root/usr/sbin/apachectl -DFOREGROUND
else
 chown -R nginx.nginx /var/www/html
 php-fpm && nginx
fi
