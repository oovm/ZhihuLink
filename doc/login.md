# 模拟登陆

TODO

# cookies 登陆

## 手动 cookies 登陆

打开知乎并登录, F12进入控制台, 复制你的 cookies.

![](https://i.loli.net/2018/03/11/5aa48e38f3576.png)

执行命令 `ZhihuCookiesReset[]`

直接粘贴入这个框即可, 不需要额外转义

![](https://i.loli.net/2018/03/11/5aa48e38cb94d.png)

## 自动 cookies 登陆

创建 zhihu.cookies 到任意 `$Path` 路径下, 然后复制你的 cookies.

ZhihuLink 启动时能自动读取其中的 cookies.

注: 文件名就叫zhihu, 后缀cookies, UTF8 编码, 里面就一行.

# 备注

原则上 cookies 是无法自动获取的, 因为出于安全因素考虑, cookies 等同于账号密码, 如果网页被挂马, cookies 被拦截发送到黑客手里就太可怕了.

所以一些重要的 cookies 是无法通过 javascript 命令获取的.

![](https://i.loli.net/2018/03/11/5aa48e38da03f.png)

可以看到 `aliyunf_tc` 是 `HttpOnly` 属性, 无法被读取.

