---
layout: post
title:  "基础设施环境搭建指南"
date:   2025-01-03 10:00:00 +0800
categories: infrastructure setup
---
## 简介

本文档旨在提供一个全面的基础设施环境搭建指南，涵盖从开发环境到生产环境的各个方面。无论您是初学者还是经验丰富的工程师，都能在这里找到有用的信息。

My service infrastructure follow the cloud native approach and the infra foundation is [kubernetes](https://kubernetes.io/ "https://kubernetes.io/").

My deployed several kubernetes in separate environments for different perpose.


### **Local Dev:**

service developer is encouraged to use kind to deploy a temp k8s to test out all the service in local dev and basic helm chart setup for their services.

### **Staging:**

Kubernetes cluster deployed on-prem instances for staging environment, CI, Integration test, scaling test are conducted in staging environment.

### **Production** :

Currently all live environment deployed customer infrastructure to be separate from other environments.

For customers require to deploy with on-prem servers, venti will deploy up-to-date kubernetes cluster on top of the servers and deploy the services.

For customers require to deploy in cloud, based on requirements we will create dedicated VPCs and kubernetes cluster first then deploy the services.

## 目录

1. 开发环境配置
2. 容器化环境
3. 持续集成/持续部署 (CI/CD)
4. 监控和日志系统
5. 安全配置

## 1. 开发环境配置

### 基础工具安装

```bash
# 更新系统包
sudo apt update
sudo apt upgrade -y

# 安装常用开发工具
sudo apt install -y git curl wget vim build-essential
```

### Git 配置

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## 2. 容器化环境

### Docker 安装

```bash
# 安装 Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 将当前用户添加到 docker 组
sudo usermod -aG docker $USER

# 启动 Docker 服务
sudo systemctl enable docker
sudo systemctl start docker
```

### Docker Compose 安装

```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## 3. CI/CD 环境

### Jenkins 安装（使用 Docker）

```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts
```

## 4. 监控和日志系统

### Prometheus 和 Grafana 安装

```yaml
# docker-compose.yml
version: '3'
services:
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
```

## 5. 安全配置

### 基础安全设置

```bash
# SSH 配置优化
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd
```

### 防火墙配置

```bash
# UFW 基础配置
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
```

## 结论

本文档提供了基础设施环境搭建的基本框架。根据具体需求，您可能需要调整或添加其他组件。建议定期更新和维护各个组件，确保系统安全性和稳定性。

## 参考资料

- [Docker 官方文档](https://docs.docker.com/)
- [Jenkins 文档](https://www.jenkins.io/doc/)
- [Prometheus 文档](https://prometheus.io/docs/introduction/overview/)
- [Grafana 文档](https://grafana.com/docs/)
