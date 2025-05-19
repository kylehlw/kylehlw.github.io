---
layout: post
title: "SSH Jumper 配置指南"
date: 2023-01-05 12:00:00 +0800
categories: [技术, 网络]
tags: [ssh, linux, 网络]
---
## 简介

Autossh 是一个实用程序，允许您在SSH隧道断开或中断时自动重新启动SSH隧道。本文将介绍如何在Linux上配置和使用Autossh。

## 安装

```
sudo apt-get install autossh 
```

## 建立ssh隧道

在我们使用 Autossh 之前，我们需要设置一个它能够管理的 SSH 隧道。在这个例子中，我们将创建一个将本地端口 8080 转发到远程服务器上端口 80 的隧道。

要创建该隧道，在终端运行以下命令：

```
ssh -L 8080:localhost:80 remote-user@remote-server 
```

此命令将建立到远程服务器的 SSH 连接，并创建一个隧道，该隧道会从本地计算机上的端口 8080 将流量转发到远程服务器上的端口 80。

一旦建立了 SSH 隧道，您可以通过打开 Web 浏览器并导航至 http：//localhost：8080 来测试它。如果一切设置正确，则应看到远程服务器的默认网页。

## 用 Autossh 管理ssh隧道

```
autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -N -f -L 8080:localhost:80 remote-user@remote-server 
```

**-M 0**选项告诉Autossh使用内置的监控端口来检测SSH隧道是否已断开连接。
**-o“ServerAliveInterval 30”**和**-o“ServerAliveCountMax 3”**选项告诉Autossh每30秒发送一次keepalive数据包，并在连续三次keepalive数据包失败时尝试重新连接。
**-N -f**选项告诉SSH在后台创建隧道而不执行任何远程命令。

## 测试autossh

要测试Autossh，断开您的互联网连接或手动停止SSH隧道按 `CTRL+C`。Autossh应该检测到隧道已断开，并自动重新启动它。

## 总结

在本文中，已经解释了如何在Linux上安装和使用Autossh。Autossh可以成为维护不稳定的或不可靠的网络连接上的持久SSH连接的一个有价值的工具。通过使用Autossh，可以确保SSH隧道即使在连接中断的情况下也能保持运行状态。

## 附 Nginx 反向代理

下载您的 相关证书 以用来启用HTTPS。

create /etc/nginx/snippets/*YOURCRTFILES*.conf

```
ssl_certificate /etc/ssl/certs/datatechnologiesnet.crt;
ssl_certificate_key /etc/ssl/private/datatechnologiesnet.key;
```

copy the certs into the above path

create /etc/nginx/sites-available/rfds-api.vendor

```json
server {
    # SSL configuration
    listen 443 ssl http2 default_server;
    listen [::]:443 ssl http2 default_server;
    include snippets/XXXX.conf;
    # for nginx in YYYY side
    server_name rfds-api.vendor;
    access_log /var/log/nginx/reverse-access.log;
    error_log /var/log/nginx/reverse-error.log;

   add_header 'Access-Control-Allow-Credentials' 'true' always;
   add_header 'Access-Control-Allow-Methods' 'GET,POST,OPTIONS,PUT,DELETE,PATCH' always;
   add_header 'Access-Control-Allow-Headers' '*' always;


    location / {
        proxy_redirect off;
        proxy_set_header Host apmrfds-api.psa;
        proxy_pass "https://10.1.?.?";
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
    }
}

```

link it at /etc/nginx/sites-enabled/rfds-api.vendor

```
sudo ln -s /etc/nginx/sites-available/rfds-api.vendor /etc/nginx/sites-enabled/rfds-api.vendor
```

check nginx config

```
sudo nginx -t
```

which show the following if everything ok

```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

let’s restart nginx

```
sudo systemctl restart nginx
```

browse using chrome to

```
https://10.1.?.??:8888/docs
```

### Refer to

[Nginx配置反向代理，一篇搞定！](https://zhuanlan.zhihu.com/p/451825018)

[How to Enable Sites in NGINX or Apache](https://www.linode.com/docs/guides/how-to-enable-disable-website/)
