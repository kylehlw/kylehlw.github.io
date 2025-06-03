---
layout: post
title: "HTTP 响应安全头详解"
date: 2020-01-02 12:00:00 +0800
categories: [Web Security]
tags: [HTTP, Security, Headers]
---
# HTTP 响应安全头详解

HTTP 响应安全头是保护 Web 应用程序安全的重要组成部分。这些头部信息可以帮助防止各种常见的 Web 攻击，如跨站脚本攻击（XSS）、点击劫持、MIME 类型嗅探等。本文将详细介绍一些最重要的安全响应头及其配置方法。

## 1. Content-Security-Policy (CSP)

Content-Security-Policy 是一个强大的安全头，用于控制页面可以加载哪些资源。

```http
Content-Security-Policy: default-src 'self'; script-src 'self' https://trusted-cdn.com; style-src 'self' 'unsafe-inline';
```

主要指令：

- `default-src`: 定义默认的资源加载策略
- `script-src`: 控制 JavaScript 的来源
- `style-src`: 控制 CSS 的来源
- `img-src`: 控制图片的来源
- `connect-src`: 控制 XHR、WebSocket 等连接的来源

For protection against **XSS** and data injection attacks  用于防止XSS和数据注入攻击

Provides a policy that ensures our trust in the source of the content 提供了一项策略，确保我们对内容来源的信任

`Content-Security-Policy: default-src 'self`

All content to come from the site's own origin (this excludes subdomains.)  所有内容均来自站点的原始来源（这不包括子域。）

`Content-Security-Policy: default-src 'self' example.com *.example.com`

Allow content from a trusted domain and all its subdomains  允许来自受信任域及其所有子域的内容

## 2. X-Frame-Options

防止网站被嵌入到 iframe 中，从而防止**点击**劫持攻击。

```http
X-Frame-Options: DENY
```

可选值：

- `DENY`: 完全禁止在 iframe 中加载
- `SAMEORIGIN`: 只允许同源页面在 iframe 中加载

To indicate whether browser should be allowed to  render a page in commands like `<frame>`, `<iframe>`, etc.

Basically, the content cannot be embedded on other sites。

指示浏览器是否应该允许在 `<frame>`、`<iframe>`等命令中呈现页面。基本上，内容不能嵌入其他网站上

## 3. X-Content-Type-Options

防止浏览器进行 MIME 类型嗅探，强制浏览器使用服务器指定的 Content-Type。

* To mitigate the threat of MIME sniffing attacks, preventing the browser from interpreting files as a different MIME type than what is specified in the Content-Type HTTP header.
* 为了减轻MIME嗅探攻击的威胁，防止浏览器将文件解释为与Content-Type HTTP标头中指定的不同MIME类型。

```http
X-Content-Type-Options: nosniff
```

## 4. Strict-Transport-Security (HSTS)

强制浏览器使用 HTTPS 连接，防止降级攻击。

```http
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
```

参数说明：

- `max-age`: HSTS 策略的有效期（秒）
- `includeSubDomains`: 包含所有子域名
- `preload`: 允许预加载到浏览器的 HSTS 预加载列表中

## 5. X-XSS-Protection

启用浏览器的 XSS 过滤功能。

Stops page from loading when they detect reflected cross-site scripting attacks

当检测到反射跨站点脚本攻击时，阻止页面加载

```http
X-XSS-Protection: 1; mode=block
```

Rather than sanitizing the page, the browser will prevent the rendering of the page if an attack is detected.

浏览器会阻止页面的呈现，而不是对页面进行消毒，如果检测到攻击

## 6. Referrer-Policy

控制 HTTP 请求中 Referer 头的信息。

This header allows control over how much detail should be disclosed, such as origin, path, and query string.

此标题允许控制应披露的详细信息量，例如来源、路径和查询字符串。

```http
Referrer-Policy: strict-origin-when-cross-origin
```

常用值：

- `no-referrer`: 不发送 Referer 头
- `same-origin`: 仅在同源时发送
- `strict-origin-when-cross-origin`: 跨域时只发送源信息

```
Referrer-Policy: no-referrer
Referrer-Policy: no-referrer-when-downgrade
Referrer-Policy: origin
Referrer-Policy: origin-when-cross-origin
Referrer-Policy: same-origin
Referrer-Policy: strict-origin
Referrer-Policy: strict-origin-when-cross-origin
Referrer-Policy: unsafe-url
```

* downgrade means from HTTPS → HTTP

## 7. Permissions-Policy

控制浏览器特性和 API 的使用权限。

```http
Permissions-Policy: geolocation=(), microphone=(), camera=()
```

To allow and deny the use of browser features in a document or within any `<iframe>` elements in the document.  允许或拒绝在文档中使用浏览器功能，或者在文档中的任何 `<iframe>`元素内使用。

* `Permissions-Policy: camera=(), microphone=(), gyroscope(), geolocation=(), display_capture(), `
* `*`: This feature is enabled for all scripts to use on the page.
* `'self'`: The current website is the only one allowed to use this feature.

## 8. X-Permitted-Cross-Domain-Policies

控制跨域策略文件（crossdomain.xml）的访问权限。

```http
X-Permitted-Cross-Domain-Policies: none
```

This header allows control over how much detail should be disclosed, such as origin, path, and query string. 控制 Web 浏览器如何处理跨域请求，例如加载资源或在不同域之间进行请求。

可选值：

- none: Indicates that no cross-domain access is allowed, and any attempts should be blocked. 表示不允许跨域访问，任何尝试都应该被阻止。

* master-only: Allows cross-domain access to the master policy file defined on the same domain. 允许对同一域名上定义的主策略文件进行跨域访问。
* by-content-type: Allows cross-domain access to other domains based on the content type of the resource being requested. 根据请求资源的内容类型来允许其他域的跨域访问。
* by-FTP filename: Allows cross-domain access to other domains based on the filename of the requested resource. 根据请求资源的文件名来允许其他域的跨域访问。
* all: When the header is set to "all," the website allows cross-domain interactions, including cross-origin requests and script inclusions. 当将标头设置为"all"时，网站允许跨域交互，包括跨源请求和脚本包含。

这个头部主要用于控制 Adobe Flash 和 PDF 等应用程序的跨域访问策略。通过限制跨域策略文件的访问，可以减少潜在的安全风险。

## 9. Clear-Site-Data

Clear-Site-Data 头部用于清除与网站相关的浏览器数据，包括 cookies、缓存、存储等。

```http
Clear-Site-Data: "cache", "cookies", "storage"
```

主要指令：

- `"cache"`: 清除浏览器缓存
- `"cookies"`: 清除所有 cookies
- `"storage"`: 清除本地存储（localStorage、sessionStorage、IndexedDB 等）
- `"executionContexts"`: 清除所有执行上下文
- `"*"`: 清除所有数据

使用场景：

- 用户登出时清除所有相关数据
- 需要强制清除用户浏览器中的敏感信息
- 确保用户会话完全终止

注意事项：

- 该头部需要 HTTPS 连接
- 只能清除当前域名下的数据
- 建议谨慎使用，因为它会影响用户体验

## 10. Cross-Origin-Embedder-Policy

Cross-Origin-Embedder-Policy (COEP) 是一个安全响应头，用于控制页面是否可以加载跨源资源。

Controls the embedding of cross-origin resources in the document

```http
Cross-Origin-Embedder-Policy: require-corp
```

主要值：

- `require-corp`: 要求所有资源必须明确选择加入跨源加载
- `credentialless`: 允许加载跨源资源，但不发送凭据（cookies、HTTP 认证等）

使用场景：

- 启用 SharedArrayBuffer 和 Performance.measureUserAgentSpecificMemory() 等高级功能
- 增强跨源隔离，防止跨源攻击
- 配合 Cross-Origin-Resource-Policy 使用，提供更细粒度的资源控制

注意事项：

- 启用 COEP 可能会影响页面的正常功能，需要确保所有资源都符合要求
- 建议配合 Cross-Origin-Resource-Policy 和 Cross-Origin-Opener-Policy 使用
- 需要仔细测试，确保不会破坏现有功能

## 11. Cross-Origin-Opener-Policy

Cross-Origin-Opener-Policy (COOP) 是一个安全响应头，用于控制页面是否可以与其他页面共享浏览上下文。

Controls how the document can be referenced by other documents

* Prevents a top-level document from sharing a browsing context group with cross-origin documents. 防止顶级文档与跨源文档共享浏览上下文组。
* Note: A browsing context is an environment in which a browser displays a document object to the user, for example, a tab, window or iframe. 注意： 浏览上下文是浏览器向用户显示文档对象的环境，例如选项卡、窗口或 iframe。

```http
Cross-Origin-Opener-Policy: same-origin
```

主要值：

- `same-origin`: 只允许同源页面共享浏览上下文
- `same-origin-allow-popups`: 允许同源页面和弹出窗口共享浏览上下文
- `unsafe-none`: 允许所有页面共享浏览上下文（不推荐）

使用场景：

- 防止跨源攻击，如 Spectre 漏洞
- 增强跨源隔离
- 配合 Cross-Origin-Embedder-Policy 使用，提供更完整的安全保护

注意事项：

- 启用 COOP 可能会影响页面的正常功能，特别是与弹出窗口相关的功能
- 建议配合 Cross-Origin-Embedder-Policy 使用
- 需要仔细测试，确保不会破坏现有功能

## 12. Cross-Origin-Resource-Policy

Cross-Origin-Resource-Policy (CORP) 是一个安全响应头，用于控制哪些网站可以加载该资源。

Controls which websites can load the resource

* Whether a  browser is able to make requests to an application or web service from a different origin. 浏览器是否能够从不同的来源向应用程序或网络服务发送请求。

```http
Cross-Origin-Resource-Policy: same-origin
```

主要值：

- `same-origin`: 只允许同源网站加载资源
- `same-site`: 允许同站（包括子域名）加载资源
- `cross-origin`: 允许任何网站加载资源

使用场景：

- 防止跨站请求伪造（CSRF）攻击
- 保护敏感资源不被其他网站加载
- 配合 Cross-Origin-Embedder-Policy 使用，提供更完整的跨源保护

注意事项：

- 该头部需要 HTTPS 连接
- 建议从最严格的配置开始（same-origin）
- 需要仔细测试，确保不会影响正常功能
- 对于需要被其他网站加载的资源（如 CDN 资源），可能需要使用 cross-origin 值

## 13. Cache-Control

Cache-Control 是一个重要的 HTTP 响应头，用于控制浏览器和中间缓存如何缓存响应内容。是一个 HTTP/1.1 的响应头。

```http
Cache-Control: max-age=3600, must-revalidate
```

主要指令：

- `max-age`: 指定资源可以被缓存的最大时间（秒）
- `no-cache`: 每次使用缓存前必须向服务器验证
- `no-store`: 不缓存响应内容
- `private`: 只允许浏览器缓存，不允许中间缓存
- `public`: 允许所有缓存（浏览器和中间缓存）
- `must-revalidate`: 缓存过期后必须向服务器验证
- `proxy-revalidate`: 要求中间缓存过期后必须向服务器验证,要么与源服务器重新验证存储的响应，要么生成一个504（网关超时）响应
- `Cache-Control: s-maxage=604800`: 响应在共享缓存中保持新鲜的时间
- `Cache-Control: private/public, immutable`:

  - `private`：响应只能存储在专用缓存中（例如浏览器中的本地缓存）。
  - `public`：响应可以存储在共享缓存中
  - `immutable`：当响应有效时，不会更新响应。
- `Cache-Control: must-understand, no-store`:

  缓存应该只在理解基于状态码的缓存要求时才存储响应。必须了解应与no-store结合使用以实现回退行为。（注意：回退行为是如果特定时间内的通信失败，要么保留最后通信值，要么采用预定义的回退值。）Cache should store the response only if it understands the requirements for caching based on status code. `must-understand` should be coupled with `no-store` for fallback behavior. (Note: Fallback behaviour is If communication fails for a specific time, either the last communicated values are kept or predefined fallback values are taken.)

使用场景：

- 静态资源（如图片、CSS、JavaScript）可以设置较长的缓存时间
- 动态内容（如用户数据）应该设置 no-cache 或 no-store
- API 响应可能需要 must-revalidate 来确保数据新鲜度

注意事项：

- 合理设置缓存时间可以提升网站性能
- 对于敏感数据，应该使用 no-store
- 需要定期更新但变化不大的资源可以使用 must-revalidate
- 建议配合 ETag 或 Last-Modified 使用，提供更精确的缓存控制

## 14. Pragma

Pragma 是一个 HTTP/1.0 的响应头，主要用于向后兼容性。它主要用于控制缓存行为，但现代浏览器更推荐使用 Cache-Control 头。

```http
Pragma: no-cache
```

主要用途：

- `no-cache`: 指示浏览器在每次请求时都必须向服务器验证缓存的有效性
- 主要用于兼容不支持 Cache-Control 的旧版 HTTP/1.0 客户端

注意事项：

- Pragma 是 HTTP/1.0 的特性，在现代 Web 开发中已经较少使用
- 建议优先使用 Cache-Control 头来控制缓存行为
- 为了最大兼容性，可以同时设置 Pragma 和 Cache-Control
- 某些代理服务器可能仍然依赖 Pragma 头

使用场景：

- 需要支持非常老的客户端时
- 与某些特殊的代理服务器交互时
- 作为 Cache-Control 的备用方案

## 最佳实践建议

1. 始终使用 HTTPS
2. 实施 CSP 策略，从最严格的配置开始
3. 启用 HSTS
4. 设置适当的 X-Frame-Options
5. 定期审查和更新安全头配置

## 配置示例

以下是一个完整的 Nginx 配置示例：

```nginx
add_header Content-Security-Policy "default-src 'self'; script-src 'self' https://trusted-cdn.com; style-src 'self' 'unsafe-inline';";
add_header X-Frame-Options "DENY";
add_header X-Content-Type-Options "nosniff";
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload";
add_header X-XSS-Protection "1; mode=block";
add_header Referrer-Policy "strict-origin-when-cross-origin";
add_header Permissions-Policy "geolocation=(), microphone=(), camera=()";
```

## 安全头检查工具

可以使用以下工具检查网站的安全头配置：

- [SecurityHeaders.com](https://securityheaders.com)
- [Mozilla Observatory](https://observatory.mozilla.org)
- [SSL Labs](https://www.ssllabs.com/ssltest/)
- [Application Security - HTTP Headers](https://www.sentrium.co.uk/labs/application-security-101-http-headers)
- [HTTP headers - HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers)

## 总结

正确配置 HTTP 安全响应头是 Web 应用程序安全的重要防线。通过实施这些安全头，可以显著提高网站的安全性，防止多种常见的 Web 攻击。建议定期审查和更新安全头配置，确保它们符合最新的安全最佳实践。
