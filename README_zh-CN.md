# sing-box-runsv

[English](README.md) | [中文](README_zh-CN.md)

把 [sing-box](https://github.com/SagerNet/sing-box) 做成开机自启的 runsv 服务，适用于 Magisk / KernelSU / APatch。

版本号跟随 sing-box 官方，分两个下载渠道：**Release**（稳定版）和 **Pre-release**（测试版）。

## 安装

1. 先安装 [runsvdir-magisk](https://github.com/sorubedo/runsvdir-magisk) 并重启手机。
2. 刷入本模块（多数手机选 `arm64-v8a`），重启手机。
3. 把配置文件放到 `/data/adb/runsvdir/service/sing-box/workdir/config.json`。

> 缺少 runsvdir-magisk 时，本模块会中止安装并提示。

## 启动

首次安装不会自动启动。推荐用模块的「操作」按钮（音量下切换，音量上执行），选「启动并启用」。也可以直接用命令：

```sh
SVC=/data/adb/runsvdir/service/sing-box

SVDIR=/data/adb/runsvdir/service sv-enable sing-box   # 启动并开机自启
SVDIR=/data/adb/runsvdir/service sv-disable sing-box  # 停止并取消自启
sv up $SVC        # 本次启动
sv down $SVC      # 本次停止
sv restart $SVC   # 重启
sv status $SVC    # 查看状态
tail -f /data/adb/runsvdir/log/sv/sing-box/current    # 查看日志
```

## 更新

覆盖刷入即可，配置和自启设置保留。如果你改过 `run` / `log/run`，安装时会用音量键询问：音量上只更新二进制，音量下同时更新脚本。更新后重启服务：

```sh
sv restart /data/adb/runsvdir/service/sing-box
```

管理器也能自己检测更新；在模块操作菜单里可切换 **稳定版 / 预发布版** 渠道。

## 卸载

卸载会删除整个服务目录，包含配置文件，注意提前备份。

## 常见问题

- **安装提示缺少 runsvdir-magisk**：先安装 runsvdir-magisk 并重启，再刷本模块。
- **服务没起来**：先看日志，或用操作按钮里的「校验配置文件」。
- **配置想放 /sdcard**：编辑服务目录下的 `run`，把 `SINGBOX_ARGS` 指向你的配置目录，并设 `WAIT_DECRYPT=1`。
