---
layout: post
title: "从零到自动化：TLS 自建证书完整指南"
date: 2025-11-12 09:00:00 +0800
categories: tls automation security
tags: [tls, ssl, openssl, automation, devops]
description: "一步步教你规划、生成、验证并自动化维护 TLS 自建证书，兼顾实验环境与小规模生产场景。"
---

# 为什么需要自建 TLS 证书 

在实验环境、内部测试系统或对外开放前的预生产环境中，使用公信 CA 颁发的证书往往成本较高、周期较长。自建证书（Self-Signed 或自建 CA）可以快速满足：

- **端到端加密**：确保敏感数据在传输过程中不被窃听。
- **客户端身份验证**：通过客户端证书实现双向 TLS。
- **快速试验**：无需等待第三方审核即可即时部署。

> ⚠️ 提醒：自建证书不适用于面向公众的正式生产站点，因为浏览器和终端默认不会信任它们，需要手动导入信任链。

# 基础概念速览

| 术语 | 说明 |
| --- | --- |
| Root CA | 最高级的证书颁发机构，自建 PKI 时通常由你掌控。 |
| Intermediate CA | 可选层级，进一步隔离 Root CA 风险。 |
| CSR | Certificate Signing Request，包含待签发证书的公钥及基本信息。 |
| SAN | Subject Alternative Name，声明证书可以匹配的域名或 IP。 |

# 前置条件

- 一台安装了 `openssl` 的 Linux 或 macOS 机器
- 可选：安装 `cfssl`、`mkcert` 等更高级工具
- 明确的证书用途（服务器/客户端/双向认证）
- 证书部署目标（Web、MQTT、消息队列等）

# Step 1：规划证书架构

```text
┌────────────┐
│ Root CA    │  ← 离线保存，极少使用
└─────┬──────┘
      │
┌─────▼──────┐
│ Server CRT │  ← 在负载均衡、MQTT Broker、API 服务等处部署
└─────┬──────┘
      │
┌─────▼──────┐
│ Client CRT │  ← 可用于双向认证，按应用/设备生成
└────────────┘
```

关键规划要点：

- SAN 要覆盖所有访问入口（域名/IP）。
- 证书有效期不宜过长，建议 1 年以内。
- Root CA 私钥应离线保存，保持最小暴露面。

# Step 2：生成自建 Root CA

```bash
mkdir -p ~/pki/{ca,server,client}
cd ~/pki

openssl genrsa -out ca/root-ca.key 4096
openssl req -x509 -new -nodes \
  -key ca/root-ca.key \
  -sha256 \
  -days 1825 \
  -out ca/root-ca.crt \
  -subj "/C=CN/ST=Shanghai/O=DemoOrg/OU=Platform/CN=Demo Root CA"
```

检查证书是否生成成功：

```bash
openssl x509 -in ca/root-ca.crt -noout -text | head
```

# Step 3：创建服务器端证书

1. **生成私钥与 CSR：**

   ```bash
   openssl genrsa -out server/server.key 2048
   openssl req -new -key server/server.key \
     -out server/server.csr \
     -subj "/C=CN/ST=Shanghai/O=DemoOrg/CN=demo.service.local"
   ```

2. **准备 OpenSSL 配置（支持 SAN）：**

   创建 `server/openssl.cnf`：

   ```
   [ req ]
   default_bits        = 2048
   prompt              = no
   default_md          = sha256
   req_extensions      = req_ext
   distinguished_name  = dn

   [ dn ]
   C  = CN
   ST = Shanghai
   O  = DemoOrg
   CN = demo.service.local

   [ req_ext ]
   subjectAltName = @alt_names

   [ alt_names ]
   DNS.1 = demo.service.local
   DNS.2 = mqtt.demo.local
   IP.1  = 10.10.10.10
   ```

3. **签发服务器证书：**

   ```bash
   openssl x509 -req \
     -in server/server.csr \
     -CA ca/root-ca.crt \
     -CAkey ca/root-ca.key \
     -CAcreateserial \
     -out server/server.crt \
     -days 365 \
     -sha256 \
     -extensions req_ext \
     -extfile server/openssl.cnf
   ```

# Step 4：创建客户端证书（可选）

```bash
openssl genrsa -out client/client.key 2048
openssl req -new -key client/client.key \
  -out client/client.csr \
  -subj "/C=CN/ST=Shanghai/O=DemoOrg/OU=IoT/CN=device-0001"

openssl x509 -req \
  -in client/client.csr \
  -CA ca/root-ca.crt \
  -CAkey ca/root-ca.key \
  -CAcreateserial \
  -out client/client.crt \
  -days 180 \
  -sha256
```

# Step 5：验证证书链

```bash
openssl verify -CAfile ca/root-ca.crt server/server.crt
openssl verify -CAfile ca/root-ca.crt client/client.crt
```

如果返回 `OK` 即表示链路有效。

# Step 6：导入信任 & 部署

**Linux / macOS 客户端：**

```bash
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ca/root-ca.crt  # macOS
sudo cp ca/root-ca.crt /usr/local/share/ca-certificates/demo-root-ca.crt && sudo update-ca-certificates  # Debian/Ubuntu
```

**常见部署示例：**

- Nginx：在 `server` 区块中配置 `ssl_certificate` 与 `ssl_certificate_key`。
- RabbitMQ/MQTT：将证书放入 `/etc/rabbitmq/certs/` 并调整 `ssl_options`.
- Kubernetes：为 `Ingress` 或 `Secret` 创建 `tls` 类型。

# 自动化思路

- **脚本化**：使用 Bash、PowerShell 或 Ansible 剧本集中管理证书生成与分发。
- **交替轮转**：编写脚本在证书到期前自动生成新证书并平滑替换。
- **集中登记**：维护证书清单（用途、到期时间、部署目标），并使用 `cron` 或 Prometheus 告警通知。

示例 Bash 脚本框架：

```bash
#!/usr/bin/env bash
set -euo pipefail

BASE_DIR=${1:-"$HOME/pki"}
DOMAIN=${2:-"demo.service.local"}
EXPIRY_DAYS=${3:-365}

# TODO: 这里补充自动化逻辑（生成目录、CSR、签发、部署等）
echo "即将为 ${DOMAIN} 生成证书，保存路径 ${BASE_DIR}"
```

# 常见问题排查

- **浏览器仍提示不受信任**：确认是否导入了 Root CA，并重启浏览器。
- **TLS 握手失败**：检查证书私钥是否匹配、SAN 是否覆盖访问域名、时间是否有效。
- **负载均衡场景证书不生效**：若使用多节点，确保所有节点同步证书及私钥。
- **客户端双向认证失败**：确认服务端配置了 `verify_peer`，且客户端证书链完整。

# 总结

通过自建 Root CA 并脚本化签发流程，可以快速搭建一套满足内部需求的 TLS 体系。完成上述步骤后，你已经具备：

- 规划证书架构的能力
- 使用 OpenSSL 生成并签发证书的技能
- 为不同业务场景部署证书的基本经验
- 自动化/轮换证书的思路

建议在测试无误后，将流程纳入 CI/CD 或配置管理工具中，以提升安全性与可维护性。祝你构建安全可靠的服务通信环境！


