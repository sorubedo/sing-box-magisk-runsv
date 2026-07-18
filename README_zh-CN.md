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

## 下载

Release 附件并**未**与上游 sing-box 版本保持同步。
请通过 GitHub Actions 获取最新构建：

1. 进入 [构建工作流](https://github.com/sorubedo/sing-box-magisk-runsv/actions/workflows/build.yml)
2. 点击 **Run workflow** → **Run workflow**
3. 等待运行完成后，从 **Artifacts** 下载 zip 文件

## 安装

1. 先安装 `runsvdir-magisk`，再在 Magisk/KernelSU 中刷入本模块。
2. **重启**设备。
3. 将 `/data/adb/sv/sing-box/conf.example` 复制为 `/data/adb/sv/sing-box/conf` 并编辑（如果使用 subsing 则为必须步骤；如果已有自己的 `config.json` 放入 `workdir/` 则可跳过）。
4. 通过 runsvdir WebUI 链接 `sing-box`，或在 root shell 中执行 `ln -s /data/adb/sv/sing-box /data/adb/runsvdir/service/`。

## 配置

创建 `/data/adb/sv/sing-box/conf` 来自定义服务。所有变量均为可选。

模块内置了一个配置模板（`template/config.json`）作为起点。**它不一定适合所有人** — 建议将你自己的 `config.json` 直接放入 `workdir/`，并设置 `UPDATE_CONFIG=0` 跳过 subsing。

### 模板配置变量

以下变量仅对内置模板生效，如果你使用自己的 `config.json` 则无影响。

| 变量 | 示例 | 说明 |
|---|---|---|
| `SUBSCRIPTION_URL` | — | 远程订阅链接（mihomo 格式） |
| `DASHBOARD_SECRET` | — | API 控制面板认证密钥 |
| `DASHBOARD_LISTEN` | — | API 控制面板监听地址 |
| `DASHBOARD_LISTEN_PORT` | — | API 控制面板监听端口 |

### 服务变量

| 变量 | 默认值 | 说明 |
|---|---|---|
| `WAIT_DECRYPT` | `0` | 启动前等待存储解密 |
| `UPDATE_CONFIG` | `1` | 启动前运行 subsing（设为 `0` 跳过） |
| `SUBSING_ARGS` | `--skip-existing ./template ./workdir` | 传递给 `subsing` 的参数 |
| `CHPST_USER` | `root:net_admin` | `chpst` 的用户和组（进程权限） |
| `SINGBOX_ARGS` | `-D ./workdir` | 传递给 `sing-box` 的参数 |

### 关于 subsing

`subsing` 是为了方便而附带的小工具 — 它根据 `template/config.json` 和你的 `SUBSCRIPTION_URL` 生成 `workdir/config.json`。**它不是必需的。** 如果你已有自己的配置文件，直接放到 `/data/adb/sv/sing-box/workdir/config.json` 并将 `UPDATE_CONFIG` 设为 `0` 即可。

默认的 `SUBSING_ARGS`（`--skip-existing`）意味着 subsing 最多执行一次：只有当 `workdir/config.json` 不存在时才会生成。具体来说：

- **手动放置配置的用户** — 将 `config.json` 放入 `workdir/`，subsing 直接跳过（0 次执行）。
- **首次启动使用模板** — subsing 生成一次配置（1 次执行）。
- **后续启动** — 配置已存在，subsing 跳过。

如果你需要每次启动时都联网拉取订阅并覆盖配置，请移除 `--skip-existing`：

```sh
SUBSING_ARGS="./template ./workdir"
```

**注意：** `runsvdir` 在开机流程中启动较早，可能早于网络就绪。此时 subsing 拉取失败会退出服务并等待 30 秒，`runsv` 会自动不断重试直到成功。

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
2. 删除 `/data/adb/sv/sing-box` 目录（包括 `workdir/` 及所有缓存数据）

若要在重装或卸载时保留配置、规则集和缓存，可将 `SUBSING_ARGS` 和 `SINGBOX_ARGS` 指向 `/data/adb/sv/sing-box/` 之外的目录，例如 `/storage/emulated/0/` 下：

```sh
SINGBOX_ARGS="-D /storage/emulated/0/sing-box"
SUBSING_ARGS="--skip-existing ./template /storage/emulated/0/sing-box"
```

若目标路径位于 `/storage/emulated/0/`，必须设置 `WAIT_DECRYPT=1` — 大多数 ROM 会加密 `/data`，媒体存储仅在开机后首次解锁时才会解密挂载，服务会等待解锁后才启动。如果你的 ROM 默认不加密，则无需 `WAIT_DECRYPT`。

## 更新二进制（开发者）

使用 `fetch.sh` 下载最新 sing-box 发布版本并打包到模块中：

```sh
./fetch.sh       # 下载各架构的最新 sing-box 和 subsing 到 bin/
./package.sh     # 生成 out/sing-box-runsv-<version>.zip
```

生成的 zip 可直接在 Magisk/KernelSU 中刷入。
