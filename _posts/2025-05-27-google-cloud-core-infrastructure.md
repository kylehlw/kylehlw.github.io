---
layout: post
title: "Google Cloud core infratructure"
date: 2025-05-27
categories: [Cloud, Google Cloud]
tags: [Google Cloud, Cloud Computing, GCP]
---
# Google Cloud 基础知识

Google Cloud Platform (GCP) 是 Google 提供的云计算平台，它提供了一系列强大的云服务，帮助企业和开发者构建、部署和扩展应用程序。本文将介绍 GCP 的基础知识。

## 什么是 Google Cloud Platform？

Google Cloud Platform 是一个完整的云计算平台，提供：

- 计算服务
- 存储服务
- 网络服务
- 大数据服务
- 人工智能和机器学习服务
- 开发者工具

根据应用的最优vCPU和内存量 微调Compute Engine虚拟机,这样就能根据工作负载情况量身定制价格。在线价格计算器可以帮助预估费用 试用网址 https://cloud.google.com/products/calculator

可用的虚拟机机器类型规格，可访问 https://cloud.google.com/compute/docs/machine-types

Google Cloud资源层次结构: 该层次结构分为四个级别 资源、项目、文件夹和组织节点。

访问Google Cloud并与之交互的四种方法：

* Google Cloud控制台
* Cloud SDK
* Cloud Shell API
* Google Cloud应用

Google Cloud的 五种核心存储方案

* Cloud Storage
* Bigtable
* Cloud SQL
* Spanner
* Firestore

Cloud Storage的四种存储类别

* 一种是Standard Storage 它用于频繁访问的热数据
* 另外两种是Nearline Storage 和Coldline Storage 它们用于不太经常访问的冷数据
* 还有一种是Archive Storage

Cloud Run 这是一个托管式计算平台 可以让你通过Web请求或Pub/Sub事件，运行无状态容器

Cloud Run functions 这是一种基于事件的轻量级异步计算解决方案，用于编写单一用途的函数

如何使用源代码构建适用于 Cloud Run 的无状态 HTTP 容器，以及如何将其推送到 Artifact Registry，请查看下面的内容：

* [开发 Cloud Run 服务](https://cloud.google.com/run/docs/developing)
* [构建容器](https://cloud.google.com/run/docs/building/containers)

## 核心服务

### 1. 计算服务

- Compute Engine：虚拟机服务
- App Engine：平台即服务 (PaaS)
- Cloud Run：容器化应用服务
- Kubernetes Engine：容器编排服务

### 2. 存储服务

- Cloud Storage：对象存储
- Cloud SQL：关系型数据库
- Cloud Bigtable：NoSQL 数据库
- Cloud Spanner：全球分布式数据库

### 3. 网络服务

- Virtual Private Cloud (VPC)
- Cloud Load Balancing
- Cloud CDN
- Cloud DNS

## 使用 GCP 的优势

1. **全球基础设施**

   - 遍布全球的数据中心
   - 低延迟访问
   - 高可用性
2. **安全性**

   - 多层安全防护
   - 数据加密
   - 身份和访问管理
3. **可扩展性**

   - 按需扩展
   - 自动扩缩容
   - 灵活的资源配置
4. **成本效益**

   - 按使用付费
   - 无前期投资
   - 资源优化

## 开始使用 GCP

1. **创建账号**

   - 访问 Google Cloud Console
   - 注册 GCP 账号
   - 设置计费信息
2. **选择项目**

   - 创建新项目
   - 设置项目 ID
   - 配置项目设置
3. **启用 API**

   - 选择需要的服务
   - 启用相应的 API
   - 配置服务权限

## 最佳实践

1. **资源管理**

   - 使用标签组织资源
   - 实施资源命名规范
   - 定期审查资源使用情况
2. **成本控制**

   - 设置预算提醒
   - 使用成本优化工具
   - 监控资源使用情况
3. **安全实践**

   - 实施最小权限原则
   - 定期更新安全策略
   - 启用安全监控

## 结论

Google Cloud Platform 提供了强大而灵活的云计算解决方案。通过了解这些基础知识，您可以更好地利用 GCP 的各种服务来构建和扩展您的应用程序。随着云计算的不断发展，GCP 将继续提供更多创新的服务和功能。

## 参考资料

- [Google Cloud 官方文档](https://cloud.google.com/docs)
- [Google Cloud Skills Boost](https://www.cloudskillsboost.google)
- [Google Cloud 架构框架](https://cloud.google.com/architecture/framework)
