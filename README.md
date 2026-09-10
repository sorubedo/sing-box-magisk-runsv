# sing-box-runsv

[English](README.md) | [中文](README_zh-CN.md)

[sing-box](https://github.com/SagerNet/sing-box) as a runsv service for Magisk/KernelSU.

This project packages the upstream sing-box binary as a runsv service for persistent background execution on Android.

| | |
|---|---|
| **Upstream** | [SagerNet/sing-box](https://github.com/SagerNet/sing-box) |
| **Upstream License** | [GPL-3.0](https://github.com/SagerNet/sing-box/blob/main/LICENSE) |

## Dependencies

- [runsvdir-magisk](https://github.com/sorubedo/runsvdir-magisk)

## Download

Release attachments are **not** kept in sync with upstream sing-box versions.
Use GitHub Actions to get the latest build:

1. Go to the [Build Workflow](https://github.com/sorubedo/sing-box-magisk-runsv/actions/workflows/build.yml)
2. Click **Run workflow** -> **Run workflow**
3. Download the artifact whose suffix matches your device: `arm64-v8a`, `armeabi-v7a`, `x86_64`, or `x86`

## Installation

1. Install `runsvdir-magisk`, then install this module in Magisk/KernelSU.
2. Reboot the device.
3. Place your sing-box configuration at `/data/adb/sv/sing-box/workdir/config.json`.
4. Optionally copy `/data/adb/sv/sing-box/conf.example` to `/data/adb/sv/sing-box/conf` and edit the service settings.
5. Enable `sing-box` from the runsvdir WebUI, or run `ln -s /data/adb/sv/sing-box /data/adb/runsvdir/service/` in a root shell.

The module does not include or generate a sing-box configuration. The service cannot start until you provide a valid configuration.

## Service Settings

Create `/data/adb/sv/sing-box/conf` to customize the service. All variables are optional.

| Variable | Default | Description |
|---|---|---|
| `WAIT_DECRYPT` | `0` | Wait for storage decryption before starting |
| `CHPST_USER` | `root:net_admin` | User and groups for `chpst` |
| `SINGBOX_ARGS` | `-D ./workdir` | Arguments passed to `sing-box` |

Example:

```sh
WAIT_DECRYPT=0
CHPST_USER="root:net_admin"
SINGBOX_ARGS="-D ./workdir"
```

To use a configuration directory outside the service directory, set `SINGBOX_ARGS` accordingly:

```sh
SINGBOX_ARGS="-D /storage/emulated/0/sing-box"
```

If the target is under `/storage/emulated/0/`, set `WAIT_DECRYPT=1` so the service starts after device storage becomes available.

## Action Button

Click the action button in Magisk/KernelSU and use the volume keys:

- **Vol Up** - Show the sing-box version
- **Vol Down** - Validate the active configuration

## Command Line

Control the service from a root shell:

```sh
sv-enable sing-box
sv-disable sing-box

sv up sing-box
sv down sing-box
sv status sing-box

tail -f /data/adb/runsvdir/log/sv/sing-box/current
sing-box -D /data/adb/sv/sing-box/workdir check
```

## Manual Binary Update

Replace the binary without reinstalling the module:

```sh
cp new-sing-box /data/adb/modules/sing-box-runsv/system/bin/sing-box
chmod +x /data/adb/modules/sing-box-runsv/system/bin/sing-box
reboot
```

## Uninstall

Uninstalling the module removes:

1. `/data/adb/runsvdir/service/sing-box`
2. `/data/adb/sv/sing-box`, including its configuration and runtime data

Store the configuration directory outside `/data/adb/sv/sing-box/` if it must survive module removal.

## Developer Build

```sh
./fetch.sh
./package.sh
```

`fetch.sh` downloads sing-box for all supported architectures. `package.sh` creates one flashable ZIP per ABI; pass ABI names to build only selected targets.
