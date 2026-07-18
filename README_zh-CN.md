# sing-box-runsv

[English](README.md) | [中文](README_zh-CN.md)

将 [sing-box](https://github.com/SagerNet/sing-box) 作为 runsv 服务运行，适用于 Magisk/KernelSU。

本项目是 [sing-box](https://github.com/SagerNet/sing-box) 的 Magisk/KernelSU 模块封装，搭配 [subsing](https://github.com/sorubedo/subsing) 进行订阅管理，将其打包为 runsv 服务，使其在 Android 设备上持久化后台运行。

| | |
|---|---|
| **上游项目** | [SagerNet/sing-box](https://github.com/SagerNet/sing-box) |
| **上游协议** | [GPL-3.0](https://github.com/SagerNet/sing-box/blob/main/LICENSE) |
| **Subsing** | [sorubedo/subsing](https://github.com/sorubedo/subsing) |

## 依赖

- [runsvdir-magisk](https://github.com/sorubedo/runsvdir-magisk)

## 功能

- 基于 TUN 的透明代理，支持 `auto_route` 和 `auto_redirect`
- SOCKS5/HTTP 混合入站，监听 `127.0.0.1:1080`
- 通过 `subsing` 自动更新订阅配置
- Web 控制面板（zashboard）自动下载
- 基于规则集的国内外分流
- FakeIP DNS 防止 DNS 泄漏

## 下载

Release 附件并**未**与上游 sing-box 版本保持同步。
请通过 GitHub Actions 获取最新构建：

1. 进入 [构建工作流](https://github.com/sorubedo/sing-box-magisk/actions/workflows/build.yml)
2. 点击 **Run workflow** → **Run workflow**
3. 等待运行完成后，从 **Artifacts** 下载 zip 文件

## 安装

1. 先安装 `runsvdir-magisk`，再在 Magisk/KernelSU 中刷入本模块。
2. **重启**设备。
3. 编辑 `/data/adb/sv/sing-box/conf`，设置你的 `SUBSCRIPTION_URL`。
4. 通过 runsvdir WebUI 链接 `sing-box`，或在 root shell 中执行 `ln -s /data/adb/sv/sing-box /data/adb/runsvdir/service/`。

## 配置

创建 `/data/adb/sv/sing-box/conf` 来自定义服务。所有变量均为可选。

| 变量 | 默认值 | 说明 |
|---|---|---|
| `SUBSCRIPTION_URL` | `""` | 远程订阅链接（mihomo 格式） |
| `DASHBOARD_SECRET` | `changeme` | API 控制面板认证密钥 |
| `DASHBOARD_LISTEN` | `127.0.0.1` | API 控制面板监听地址 |
| `DASHBOARD_LISTEN_PORT` | `23333` | API 控制面板监听端口 |
| `WAIT_DECRYPT` | `0` | 启动前等待存储解密 |
| `UPDATE_CONFIG` | `1` | 启动前运行 subsing 更新配置（设为 `0` 跳过） |
| `SUBSING_ARGS` | `--skip-existing ./template ./workdir` | 传递给 `subsing` 的参数 |
| `CHPST_USER` | `root:net_admin` | `chpst` 的用户和组（进程权限） |
| `SINGBOX_ARGS` | `-D ./workdir` | 传递给 `sing-box` 的参数 |

示例：

```sh
SUBSCRIPTION_URL="https://your.subscription.link"
DASHBOARD_SECRET=mysecret
DASHBOARD_LISTEN=127.0.0.1
DASHBOARD_LISTEN_PORT=23333
WAIT_DECRYPT=0
UPDATE_CONFIG=1
```

## 操作按钮

在 Magisk/KernelSU 中点击操作按钮，通过音量键执行：

- **音量+** — 显示 sing-box 版本
- **音量-** — 验证运行配置

## 命令行

也可以通过 root shell 控制服务，无需 runsvdir WebUI：

```sh
# 启用 / 禁用
sv-enable sing-box
sv-disable sing-box

# 启动 / 停止 / 状态
sv up sing-box
sv down sing-box
sv status sing-box

# 查看 svlogd 日志
tail -f /data/adb/runsvdir/log/sv/sing-box/current

# 检查配置
sing-box -D /data/adb/sv/sing-box/workdir check
```

## 手动更新二进制

无需重新安装整个模块，直接替换二进制文件：

```sh
cp new-sing-box /data/adb/modules/sing-box-runsv/system/bin/sing-box
chmod +x /data/adb/modules/sing-box-runsv/system/bin/sing-box
reboot
```

## 卸载

通过 Magisk/KernelSU 管理器卸载本模块。这将：

1. 移除 `/data/adb/runsvdir/service/sing-box` 软链接
2. 删除 `/data/adb/sv/sing-box` 目录

`/data/adb/sv/sing-box/workdir` 下的数据不会被删除。

## 更新二进制（开发者）

使用 `fetch.sh` 下载最新 sing-box 发布版本并打包到模块中：

```sh
./fetch.sh       # 下载各架构的最新 sing-box 和 subsing 到 bin/
./package.sh     # 生成 out/sing-box-runsv-<version>.zip
```

生成的 zip 可直接在 Magisk/KernelSU 中刷入。
