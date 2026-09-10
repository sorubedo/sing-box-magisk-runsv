# sing-box-runsv

[English](README.md) | [中文](README_zh-CN.md)

将 [sing-box](https://github.com/SagerNet/sing-box) 作为 runsv 服务运行，适用于 Magisk/KernelSU。

本项目将上游 sing-box 二进制封装为 runsv 服务，使其在 Android 设备上持久化后台运行。

| | |
|---|---|
| **上游项目** | [SagerNet/sing-box](https://github.com/SagerNet/sing-box) |
| **上游协议** | [GPL-3.0](https://github.com/SagerNet/sing-box/blob/main/LICENSE) |

## 依赖

- [runsvdir-magisk](https://github.com/sorubedo/runsvdir-magisk)

## 下载

Release 附件并**未**与上游 sing-box 版本保持同步。请通过 GitHub Actions 获取最新构建：

1. 进入[构建工作流](https://github.com/sorubedo/sing-box-magisk-runsv/actions/workflows/build.yml)
2. 点击 **Run workflow** -> **Run workflow**
3. 下载后缀与设备匹配的 Artifact：`arm64-v8a`、`armeabi-v7a`、`x86_64` 或 `x86`

## 安装

1. 安装 `runsvdir-magisk`，再在 Magisk/KernelSU 中刷入本模块。
2. 重启设备。
3. 将自己的 sing-box 配置放到 `/data/adb/sv/sing-box/workdir/config.json`。
4. 可选：将 `/data/adb/sv/sing-box/conf.example` 复制为 `/data/adb/sv/sing-box/conf`，然后修改服务参数。
5. 通过 runsvdir WebUI 启用 `sing-box`，或在 root shell 中执行 `ln -s /data/adb/sv/sing-box /data/adb/runsvdir/service/`。

模块不内置、也不生成 sing-box 配置。用户提供有效配置前，服务无法正常启动。

## 服务参数

创建 `/data/adb/sv/sing-box/conf` 可自定义服务。所有变量均为可选。

| 变量 | 默认值 | 说明 |
|---|---|---|
| `WAIT_DECRYPT` | `0` | 启动前等待存储解密 |
| `CHPST_USER` | `root:net_admin` | `chpst` 使用的用户和组 |
| `SINGBOX_ARGS` | `-D ./workdir` | 传递给 `sing-box` 的参数 |

示例：

```sh
WAIT_DECRYPT=0
CHPST_USER="root:net_admin"
SINGBOX_ARGS="-D ./workdir"
```

如需使用服务目录之外的配置目录，请修改 `SINGBOX_ARGS`：

```sh
SINGBOX_ARGS="-D /storage/emulated/0/sing-box"
```

如果目标路径位于 `/storage/emulated/0/`，请设置 `WAIT_DECRYPT=1`，让服务在设备存储可用后再启动。

## 操作按钮

在 Magisk/KernelSU 中点击操作按钮，通过音量键执行：

- **音量+** - 显示 sing-box 版本
- **音量-** - 验证当前配置

## 命令行

可在 root shell 中控制服务：

```sh
sv-enable sing-box
sv-disable sing-box

sv up sing-box
sv down sing-box
sv status sing-box

tail -f /data/adb/runsvdir/log/sv/sing-box/current
sing-box -D /data/adb/sv/sing-box/workdir check
```

## 手动更新二进制

无需重装模块即可替换 sing-box 二进制：

```sh
cp new-sing-box /data/adb/modules/sing-box-runsv/system/bin/sing-box
chmod +x /data/adb/modules/sing-box-runsv/system/bin/sing-box
reboot
```

## 卸载

卸载模块会删除：

1. `/data/adb/runsvdir/service/sing-box`
2. `/data/adb/sv/sing-box`，包括其中的配置与运行数据

如果配置需要在模块卸载后保留，请将配置目录放在 `/data/adb/sv/sing-box/` 之外。

## 开发者构建

```sh
./fetch.sh
./package.sh
```

`fetch.sh` 下载所有支持架构的 sing-box，`package.sh` 为每个 ABI 生成可刷入的 ZIP；也可向 `package.sh` 传入 ABI 名称，只构建指定目标。
