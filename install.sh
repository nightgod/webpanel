#!/bin/sh
# Author:  nightgod (davidng@gmail.com)
# Web:  http://www.odvps.com
# Explain : This is a test Edition
echo -e "# Firewall configuration written by system-config-firewall\n# Manual customization of this file is not recommended.\n*filter\n:INPUT ACCEPT [0:0]\n:FORWARD ACCEPT [0:0]\n:OUTPUT ACCEPT [0:0]\n-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT\n-A INPUT -p icmp -j ACCEPT\n-A INPUT -i lo -j ACCEPT\n-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT\n-A INPUT -m state --state NEW -m tcp -p tcp --dport 21 -j ACCEPT\n-A INPUT -m state --state NEW -m tcp -p tcp --dport 10045:10090 -j ACCEPT\n-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT\n-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT\n-A INPUT -j REJECT --reject-with icmp-host-prohibited\n-A FORWARD -j REJECT --reject-with icmp-host-prohibited\nCOMMIT" > /etc/sysconfig/iptables
service iptables restart
echo -e "#SELINUX=enforcing\n#SELINUXTYPE=targeted\nSELINUX=disabled\nSETLOCALDEFS=0" > /etc/selinux/config
yum install -y make apr* autoconf automake curl-devel gcc gcc-c++ gtk+-devel  zlib-devel openssl openssl-devel pcre-devel gd  gettext gettext-devel kernel keyutils  patch  perl kernel-headers compat* mpfr cpp glibc libgomp libstdc++-devel ppl cloog-ppl keyutils-libs-devel libcom_err-devel libsepol-devel libselinux-devel krb5-devel  libXpm* freetype freetype-devel freetype* fontconfig fontconfig-devel libjpeg* libpng* php-common php-gd ncurses* libtool* libxml2 libxml2-devel patch policycoreutils bison
cp -r Packages/* /usr/local/src
cd /usr/local/src
tar zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure
make
make install
cd /usr/local/src
tar zxvf cmake-2.8.11.2.tar.gz
cd cmake-2.8.11.2
./configure
make
make install
cd /usr/local/src
mkdir /usr/local/pcre
tar zxvf pcre-8.33.tar.gz
cd pcre-8.33
./configure --prefix=/usr/local/pcre
make
make install
cd /usr/local/src
tar zxvf libunwind-1.1.tar.gz
cd libunwind-1.1
./configure
make
make install
cd /usr/local/src
tar zxvf gperftools-2.0.tar.gz
cd gperftools-2.0
./configure --enable-frame-pointers
make
make install
echo -e "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf
/sbin/ldconfig
groupadd mysql
useradd -g mysql mysql -s /bin/false
mkdir -p /data/mysql
chown -R mysql:mysql /data/mysql
mkdir -p /usr/local/mysql
cd /usr/local/src
tar zxvf mysql-5.6.13.tar.gz
cd mysql-5.6.13
cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql  -DMYSQL_DATADIR=/data/mysql  -DSYSCONFDIR=/etc  -DENABLE_DOWNLOADS=1
make
make install
rm -rf /etc/my.cnf
cd /usr/local/mysql
./scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/data/mysql
ln -s /usr/local/mysql/my.cnf /etc/my.cnf
cp ./support-files/mysql.server  /etc/rc.d/init.d/mysqld
chmod 755 /etc/init.d/mysqld
chkconfig mysqld on
echo 'basedir=/usr/local/mysql/' >> /etc/rc.d/init.d/mysqld
echo 'datadir=/data/mysql/' >>/etc/rc.d/init.d/mysqld
service mysqld start
echo 'export PATH=$PATH:/usr/local/mysql/bin' >> /etc/profile
ln -s /usr/local/mysql/lib/mysql /usr/lib/mysql
ln -s /usr/local/mysql/include/mysql /usr/include/mysql
mkdir /var/lib/mysql
ln -s /tmp/mysql.sock  /var/lib/mysql/mysql.sock
groupadd www
useradd -g www www -s /bin/false
cd /usr/local/src
tar zxvf nginx-1.4.2.tar.gz
cd nginx-1.4.2
./configure --prefix=/usr/local/nginx --with-google_perftools_module  --without-http_memcached_module --user=www --group=www --with-http_stub_status_module --with-openssl=/usr/ --with-pcre=/usr/local/src/pcre-8.33
make
make install
mkdir /tmp/tcmalloc
chmod  777 /tmp/tcmalloc -R
/usr/local/nginx/sbin/nginx
cp /usr/local/src/etc/nginx  /etc/rc.d/init.d/nginx
chmod 775 /etc/rc.d/init.d/nginx
chkconfig nginx on
/etc/rc.d/init.d/nginx restart
cd /usr/local/src
tar zxvf gd-2.0.36RC1.tar.gz
cd gd-2.0.36RC1
./configure --enable-m4_pattern_allow  --prefix=/usr/local/gd  --with-jpeg=/usr/lib  --with-png=/usr/lib  --with-xpm=/usr/lib  --with-freetype=/usr/lib  --with-fontconfig=/usr/lib
make
make install
cd /usr/local/src
tar -zvxf php-5.3.27.tar.gz
cd php-5.3.27
mkdir -p /usr/local/php5
./configure --prefix=/usr/local/php5 --with-config-file-path=/usr/local/php5/etc --with-mysql=/usr/local/mysql --with-mysqli=/usr/local/mysql/bin/mysql_config --with-mysql-sock=/tmp/mysql.sock --with-pdo-mysql=/usr/local/mysql --with-gd=/usr/local/gd  --with-png-dir=/usr/lib --with-jpeg-dir=/usr/lib --with-freetype-dir=/usr/lib --with-iconv  --with-zlib  --enable-xml --enable-magic-quotes --enable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curlwrappers --enable-mbregex  --enable-fpm --enable-mbstring --enable-ftp --enable-gd-native-ttf --with-openssl --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --without-pear --with-gettext --enable-session --with-mcrypt --with-curl --enable-ctype
make
make install
cp php.ini-production /usr/local/php5/etc/php.ini
rm -rf /etc/php.ini
ln -s /usr/local/php5/etc/php.ini /etc/php.ini
cp /usr/local/php5/etc/php-fpm.conf.default /usr/local/php5/etc/php-fpm.conf
cp /usr/local/src/etc/php-fpm.conf /usr/local/php5/etc/php-fpm.conf
cp /usr/local/src/php-5.3.27/sapi/fpm/init.d.php-fpm  /etc/rc.d/init.d/php-fpm
chmod +x /etc/rc.d/init.d/php-fpm
chkconfig php-fpm on
cp /usr/local/src/etc/php.ini /usr/local/php5/etc/php.ini
cp /usr/local/src/etc/nginx.conf  /usr/local/nginx/conf/nginx.conf
cp /usr/local/src/etc/rewrite.conf  /usr/local/nginx/conf/rewrite.conf
touch /tmp/php-cgi.sock
chown www.www /tmp/php-cgi.sock
cp /usr/local/src/etc/fcgi.conf /usr/local/nginx/conf/fcgi.conf
mkdir /usr/local/nginx/conf/vhost
cp /usr/local/src/etc/localhost.conf /usr/local/nginx/conf/vhost/localhost.conf
cd /usr/local/src
mkdir /usr/local/zend
tar xvfz ZendGuardLoader-php-5.3-linux-glibc23-i386.tar.gz
cp ZendGuardLoader-php-5.3-linux-glibc23-i386/php-5.3.x/ZendGuardLoader.so /usr/local/zend/
cd /usr/local/src
tar -zxvf re2c-0.13.5.tar.gz
cd re2c-0.13.5
./configure
make
make install
cd /usr/local/src
tar zxvf ioncube_loaders_lin_x86.tar.gz
mkdir /usr/local/ioncube
cp -rf ioncube/*  /usr/local/ioncube
cd /usr/local/src
tar xjf eaccelerator-0.9.6.1.tar.bz2
cd eaccelerator-0.9.6.1
/usr/local/php5/bin/phpize
./configure -enable-eaccelerator=shared --with-php-config=/usr/local/php5/bin/php-config
make
make install
mkdir /tmp/eaccelerator
chmod 777 /tmp/eaccelerator
cd /usr/local/src
tar zxvf memcache-2.2.6.tgz
cd memcache-2.2.6
/usr/local/php5/bin/phpize
./configure  --with-php-config=/usr/local/php5/bin/php-config
make
make install
cd /usr/local/src
tar zxvf suhosin-0.9.33.tgz
cd suhosin-0.9.33
/usr/local/php5/bin/phpize
./configure  --with-php-config=/usr/local/php5/bin/php-config
make
make install
cd /usr/local/src
tar zxvf ImageMagick.tar.gz
cd ImageMagick-6.7.9-3
./configure --prefix=/usr/local/imagemagick
make
make install
export PKG_CONFIG_PATH=/usr/local/imagemagick/lib/pkgconfig/
cd /usr/local/src
tar zxvf imagick-3.0.1.tgz
cd imagick-3.0.1
/usr/local/php5/bin/phpize
./configure  --with-php-config=/usr/local/php5/bin/php-config --with-imagick=/usr/local/imagemagick
make
make install
cd /usr/local/src
tar zxvf MagickWandForPHP-1.0.8.tar.gz
cd MagickWandForPHP-1.0.8
/usr/local/php5/bin/phpize
./configure  --with-php-config=/usr/local/php5/bin/php-config --with-magickwand=/usr/local/imagemagick
make
make install
cd /usr/local/src
tar zxvf phpredis-master.tar.gz
cd phpredis-master
/usr/local/php5/bin/phpize
./configure --with-php-config=/usr/local/php5/bin/php-config
make
make install
cd /usr/local/nginx/html/
rm -rf /usr/local/nginx/html/*
#echo -e "<?php\nphpinfo();\n?>" > index.php
cp /usr/local/src/etc/index.php  /usr/local/nginx/html/index.php
cp /usr/local/src/etc/gd.php  /usr/local/nginx/html/gd.php
cp /usr/local/src/etc/server.php  /usr/local/nginx/html/server.php
cp /usr/local/src/etc/phpinfo.php  /usr/local/nginx/html/phpinfo.php
cp /usr/local/src/etc/vhost.sh /home/vhost.sh
chmod +x /home/vhost.sh
chown www.www /usr/local/nginx/html/ -R
chmod 700 /usr/local/nginx/html/ -R
yum install -y db4* vsftpd
/etc/init.d/vsftpd start
chkconfig vsftpd on
sed -i "s/anonymous_enable=YES/anonymous_enable=NO/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#anon_upload_enable=YES/anon_upload_enable=NO/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#anon_mkdir_write_enable=YES/anon_mkdir_write_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#chown_uploads=YES/chown_uploads=NO/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#async_abor_enable=YES/async_abor_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#ascii_upload_enable=YES/ascii_upload_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#ascii_download_enable=YES/ascii_download_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#ftpd_banner=Welcome to blah FTP service./ftpd_banner=Welcome to osyunwei.com FTP service./g" '/etc/vsftpd/vsftpd.conf'
echo -e "use_localtime=YES\nlisten_port=21\nchroot_local_user=YES\nidle_session_timeout=300\ndata_connection_timeout=1\nguest_enable=YES\nguest_username=www\nuser_config_dir=/etc/vsftpd/vconf\nvirtual_use_local_privs=YES\npasv_min_port=10045\npasv_max_port=10090\naccept_timeout=5\nconnect_timeout=1" >> /etc/vsftpd/vsftpd.conf
touch /etc/vsftpd/virtusers
db_load -T -t hash -f /etc/vsftpd/virtusers /etc/vsftpd/virtusers.db
chmod 600 /etc/vsftpd/virtusers.db
sed -i '1i\auth sufficient /lib/security/pam_userdb.so db=/etc/vsftpd/virtusers\naccount sufficient /lib/security/pam_userdb.so db=/etc/vsftpd/virtusers' /etc/pam.d/vsftpd
mkdir  /etc/vsftpd/vconf
/etc/init.d/vsftpd restart
/etc/init.d/vsftpd stop
shutdown -r now
