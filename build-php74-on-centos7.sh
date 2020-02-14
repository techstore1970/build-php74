#!/bin/bash

#注意，当前脚本适合centos7且未安装过PHP的机器，如已安装过PHP，请在编译完成后，手动安装
#注意，我的默认登录账户是centos

#依赖环境
sudo yum -y install epel-release

sudo yum -y install unzip make wget vim pcre pcre-devel openssl openssl-devel libicu-devel gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel ncurses ncurses-devel curl curl-devel krb5-devel libidn libidn-devel openldap openldap-devel jemalloc-devel cmake boost-devel bison automake libevent libevent-devel gd gd-devel libtool* libmcrypt libmcrypt-devel mcrypt mhash libxslt libxslt-devel readline readline-devel gmp gmp-devel libcurl libcurl-devel openjpeg-devel e2fsprogs e2fsprogs-devel GraphicsMagick-devel libsqlite3x libsqlite3x-devel oniguruma oniguruma-devel

#创建用户与用户组
sudo groupadd -r www-data
sudo useradd -g www-data www-data -M

#创建
cd /usr/local/src
wget https://www.php.net/distributions/php-7.4.2.tar.gz
tar xzvf php-7.4.2.tar.gz
cd php-7.4.2

#配置
./configure \
--prefix=/usr/local/php74 \
--with-config-file-path=/usr/local/php74/etc \
--enable-fpm \
--enable-mysqlnd \
--enable-mysqlnd-compression-support \
--enable-xml \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--enable-mbregex \
--enable-mbstring \
--enable-intl \
--enable-ftp \
--enable-pcntl \
--enable-sockets  \
--enable-maintainer-zts \
--enable-opcache \
--with-fpm-user=www-data \
--with-fpm-group=www-data \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--enable-gd \
--with-iconv \
--with-freetype \
--with-jpeg \
--with-zlib \
--with-libxml \
--with-curl \
--with-openssl \
--with-mhash \
--with-xmlrpc \
--with-gettext \
--with-pear \
--disable-ipv6 \
--disable-debug \
--disable-fileinfo \
--disable-maintainer-zts

make 

sudo make install

#复制配置文件
sudo cp /usr/local/src/php-7.4.2/sapi/fpm/php-fpm.conf /usr/local/php74/etc
sudo cp /usr/local/src/php-7.4.2/sapi/fpm/www.conf /usr/local/php74/etc/php-fpm.d/
sudo cp /usr/local/src/php-7.4.2/php.ini-production /usr/local/php74/etc/php.ini

# 程序提供的配置文件需要修改一些配置项
# sudo cp /usr/local/src/php-7.4.2/sapi/fpm/php-fpm.service /usr/lib/systemd/system/

# 本文采用配置文件如下
wget https://raw.githubusercontent.com/techstore1970/build-php74/master/php-fpm.service 
sudo cp php-fpm.service /usr/lib/systemd/system/

# 更新系统配置
sudo systemctl daemon-reload
# 配置开机启动
sudo systemctl enable php-fpm
# 启动php-fpm
sudo systemctl start php-fpm
