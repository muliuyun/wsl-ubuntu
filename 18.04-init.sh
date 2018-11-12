#!/bin/bash
# env init:
#       This script for wsl ubuntu 18.04 ps. repeat is safe
#       if not use root, need sudo.
# History:
## 2018/11/12    yun   First release

# backup and change sources
cp /etc/apt/sources.list /etc/apt/sources.list.bak
sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu/http:\/\/mirrors.163.com\/ubuntu/g' /etc/apt/sources.list
sed -i 's/http:\/\/security.ubuntu.com\/ubuntu/http:\/\/mirrors.163.com\/ubuntu/g' /etc/apt/sources.list


apt update && apt -y upgrade && apt install -y php-curl php-fpm php-mbstring php-mysql php-xml php-zip php-gd php-dev php-pear php-bcmath composer nginx redis mysql-server libpng-dev


# for safe cgi.fix_pathinfo=0
cp /etc/php/7.2/fpm/php.ini /etc/php/7.2/fpm/php.ini.bak
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.2/fpm/php.ini

# wsl tcp bug fastcgi_buffering off;
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

grep "fastcgi_buffering off;" /etc/nginx/nginx.conf >/dev/null
if [ $? -ne 0 ]; then
     sed -i 's/sendfile on;/&\n\tfastcgi_buffering off;/' /etc/nginx/nginx.conf
fi

# 国内下载node源较慢，推荐代理安装，可看情况打开下两行.
# curl -sL https://deb.nodesource.com/setup_11.x | bash -
# apt install -y nodejs
