## 安装
1. win+x 打开powershell(管理员):
	`Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux`
	(可能需重启)
2. 打开商店搜索 ubuntu，(本文以18.04为例)，点击安装，会出现一个终端等待几分钟输入帐号与密码。（一般几分钟即可，极小几率会出现终端一直卡住的情况，可以按下enter试试.)
3. exit(ctrl+d)退出，在命令行下（推荐使用cmder)输入`wsl`或者`bash`来进入子系统.
>ps. 安装位置可以通过，`系统->存储->更改新内容保存位置`，来选择非C盘。
>ps2. 可用 `lxrun /setdefaultuser root` (windows下命令) 来设置子系统的默认使用帐号.

## 环境
1. 将此脚本保存执行: https://github.com/muliuyun/wsl-ubuntu/blob/master/18.04-init.sh (sudo bash 18.04-init.sh)
2. 配置 `nginx`, 举例:
	
	$sudo nano /etc/nginx/conf.d/blog.conf;
	server {
		listen 80;
		server_name blog.test;
		root "/mnt/d/project/blog/public/";

		index index.html index.htm index.php;
	
		location / {
			try_files $uri $uri/ /index.php?$query_string; #laravel 框架需要此行
		}
	
		location ~ \.php$ {
			include snippets/fastcgi-php.conf;
			fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
		}
	}
3. 设置host
>  ps. cmder在子系统中使用vim光标不能左右动（此bug有能解决的人，请指教)

## 启动
>使用 service start nginx，service start redis-server启动各个服务即可。
>因wsl不支持服务自启动，每次开机后都打稍有些麻烦，这里采用[github issues](https://github.com/Microsoft/WSL/issues/3318#issuecomment-399174194)上的一个办法。将下面脚本保存，并将路径加入到home下的.bashrc里即可在进入子系统时自动开启服务。
	
例子:

	root@DESKTOP-K67IOON:~# pwd
	/root
	root@DESKTOP-K67IOON:~# cat startservers.sh
	#!/bin/bash
	# Edit this for your relevant services.
	services=(php7.2-fpm nginx redis-server mysql)
	for service in "${services[@]}"
	do
			 if (( $(ps -ef | grep -v grep | grep $service | wc -l) == 0 ))
			 then
			 # Uncomment to get messages. #
			 #echo "Starting service ${service}"
			 (sudo service $service start > /dev/null &)
			 fi
	done
	root@DESKTOP-K67IOON:~# cat .bashrc |grep startservers.sh
	~/startservers.sh

## 问题
1. php-fpm不能使用tcp只能使用unixsocket方式。
2. git clone后会导致，两边文件系统不一致，最好在windows下使用git 拉取代码.
3. 将mysql的`datadir`指定到windows下(mnt)的路径，会出错.
4. 无法支持服务自启动.

## 代理
1. 可以使用 export http_proxy 来设置。
2. 不过我用的是`proxychains4`，感觉不错。

##  卸载
	lxrun /uninstall /full    # 多个子系统会一起清除.
## 使用总结
Vagrant、dokcer、Phpstudy、Laragon基本上都尝试过，感觉各有各的问题和麻烦吧。经过一段时间的使用，感觉WSL基本上满足开发的需求，还有好多有意思的功能，几个bug影响也不大。而且更新速度快，之后可能还会有更多的功能上线，还是推荐使用的^_^.

## more
大家有什么好玩的、想问的欢迎留言。感兴趣的话也可以去[windows wsl](https://docs.microsoft.com/zh-cn/windows/wsl/about)看看。


