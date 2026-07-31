---
title: "Terraform 在 Ubuntu 22.04 上的首次安装指南"
date: 2026-07-31 10:00:00 +0800
categories: [Linux, Terraform, 运维]
tags: [ubuntu, terraform, iac, 基础设施即代码, 安装]
---
# Terraform 在 Ubuntu 22.04 上的首次安装指南

## 环境准备

- 操作系统：Ubuntu 22.04 LTS
- 需要具备 sudo 权限
- 推荐先更新系统：

```bash
sudo apt update && sudo apt upgrade -y
```

## 安装依赖

安装 `gnupg`、`software-properties-common` 和 `curl`：

```bash
sudo apt install -y gnupg software-properties-common curl wget
```

## 添加 HashiCorp GPG 密钥

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
```


验证密钥指纹：

```bash
gpg --no-default-keyring \
  --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
  --fingerprint
```

gpg 命令将报告密钥指纹：

```bash
/usr/share/keyrings/hashicorp-archive-keyring.gpg
-------------------------------------------------
pub   rsa4096 20XX-01-10 [SC] [expires: 2028-01-09]
      AAAA AAAA AAAA AAAA AAAA  AAAA AAAA AAAA AAAA AAAA
uid           [ unknown] HashiCorp Security (HashiCorp Package Signing) <security+packaging@hashicorp.com>
sub   rsa4096 20AA-01-10 [S] [expires: 2028-01-09]
```

## 添加 HashiCorp 官方 APT 仓库

```bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
```

## 安装 Terraform

```bash
sudo apt update && sudo apt install -y terraform
```

## 验证安装

```bash
terraform -version
```

输出示例：

```
Terraform v1.x.x
on linux_amd64
```

## 第一个 Terraform 项目

### 1. 创建工作目录

```bash
mkdir ~/terraform-demo && cd ~/terraform-demo
```

### 2. 创建配置文件

创建 `main.tf`：

```hcl
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

resource "local_file" "hello" {
  content  = "Hello, Terraform!"
  filename = "${path.module}/hello.txt"
}
```

### 3. 初始化项目

```bash
terraform init
```

### 4. 查看执行计划

```bash
terraform plan
```

### 5. 应用配置

```bash
terraform apply
```

输入 `yes` 确认后，Terraform 会创建 `hello.txt` 文件。

### 6. 验证结果

```bash
cat hello.txt
# Hello, Terraform!
```

### 7. 销毁资源（可选）

```bash
terraform destroy
```

## 常用命令速查

| 命令 | 说明 |
|------|------|
| `terraform init` | 初始化工作目录，下载 provider 插件 |
| `terraform plan` | 预览将要执行的变更 |
| `terraform apply` | 应用配置，创建/更新资源 |
| `terraform destroy` | 销毁所有由 Terraform 管理的资源 |
| `terraform fmt` | 格式化 `.tf` 文件 |
| `terraform validate` | 验证配置文件语法 |
| `terraform show` | 显示当前状态 |
| `terraform output` | 显示输出变量 |

## 参考资料

- [Terraform 官方文档](https://developer.hashicorp.com/terraform/docs)
- [HashiCorp APT 仓库](https://apt.releases.hashicorp.com)
- [Terraform Provider Registry](https://registry.terraform.io)
