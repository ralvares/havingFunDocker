FROM registry.access.redhat.com/rhel7

COPY extras.repo /etc/yum.repos.d/extras.repo

RUN rpm -e --justdb --nodeps openssl-libs systemd systemd-libs && yum -y install systemd systemd-libs openssl-libs && sed -i 's/enabled = 0/enabled = 1/g' /etc/yum.repos.d/redhat.repo && yum -y install rh-php56-php-gd more-php56-php-mcrypt more-php56-php-pecl-redis oracle-instantclient12* nginx16 nginx16-nginx nginx16-runtime rh-php56 rh-php56-php rh-php56-php-bcmath rh-php56-php-cli rh-php56-php-common rh-php56-php-dba rh-php56-php-devel rh-php56-php-embedded rh-php56-php-enchant rh-php56-php-fpm rh-php56-php-gmp rh-php56-php-intl rh-php56-php-ldap rh-php56-php-mbstring rh-php56-php-mysqlnd rh-php56-php-odbc rh-php56-php-opcache rh-php56-php-pdo rh-php56-php-pear.noarch rh-php56-php-pecl-jsonc rh-php56-php-pecl-jsonc-devel rh-php56-php-pecl-memcache rh-php56-php-pecl-mongo rh-php56-php-pgsql rh-php56-php-process rh-php56-php-pspell rh-php56-php-recode rh-php56-php-snmp rh-php56-php-soap rh-php56-php-xml rh-php56-php-xmlrpc rh-php56-runtime rh-php56-scldevel && mkdir -p /var/www/html && chmod +s /var/www/html

COPY startup.sh /usr/bin/startup.sh
COPY conf/nginx.conf /opt/rh/nginx16/root/etc/nginx/nginx.conf
RUN chmod +x /usr/bin/startup.sh && echo "daemon off;" >> /opt/rh/nginx16/root/etc/nginx/nginx.conf
COPY conf/php.ini /etc/opt/rh/rh-php56/
COPY conf/www.conf /etc/opt/rh/rh-php56/php-fpm.d/
COPY conf/oci8.ini /etc/opt/rh/rh-php56/php.d/
COPY conf/oci8.so /opt/rh/rh-php56/root/usr/lib64/php/modules/

EXPOSE 80

CMD ["/usr/bin/startup.sh"]
