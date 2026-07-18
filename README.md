# sing-box-runsv

[English](README.md) | [中文](README_zh-CN.md)

[sing-box](https://github.com/SagerNet/sing-box) as a runsv service for Magisk/KernelSU.

This project is a Magisk/KernelSU module wrapper for [sing-box](https://github.com/SagerNet/sing-box), packaging the upstream binary with [subsing](https://github.com/sorubedo/subsing) for subscription management as a runsv service for persistent background execution on Android.

| | |
|---|---|
| **Upstream** | [SagerNet/sing-box](https://github.com/SagerNet/sing-box) |
| **Upstream License** | [GPL-3.0](https://github.com/SagerNet/sing-box/blob/main/LICENSE) |
| **Subsing** | [sorubedo/subsing](https://github.com/sorubedo/subsing) |

## Dependencies

- [runsvdir-magisk](https://github.com/sorubedo/runsvdir-magisk)

## Features

- TUN-based transparent proxy with `auto_route` and `auto_redirect`
- SOCKS5/HTTP mixed inbound on `127.0.0.1:1080`
- Subscription auto-update via `subsing` with template-based config generation
- Web dashboard (zashboard) with auto-download
- Rule-set based geo-routing (China/international split)
- FakeIP DNS to prevent DNS leaks

## Download

Release attachments are **not** kept in sync with upstream sing-box versions.
Use GitHub Actions to get the latest build:

1. Go to the [Build Workflow](https://github.com/sorubedo/sing-box-magisk/actions/workflows/build.yml)
2. Click **Run workflow** → **Run workflow**
3. Wait for the run to finish, then download the zip from **Artifacts**

## Installation

1. Install `runsvdir-magisk` first, then install this module in Magisk/KernelSU.
2. **Reboot** your device.
3. Edit `/data/adb/sv/sing-box/conf` to set your `SUBSCRIPTION_URL`.
4. Symlink `sing-box` from the runsvdir WebUI or run `ln -s /data/adb/sv/sing-box /data/adb/runsvdir/service/` in a root shell.

## Configuration

Create `/data/adb/sv/sing-box/conf` to customize the service. All variables are optional.

| Variable | Default | Description |
|---|---|---|
| `SUBSCRIPTION_URL` | `""` | Remote subscription URL for proxy nodes (mihomo format) |
| `DASHBOARD_SECRET` | `changeme` | API dashboard authentication secret |
| `DASHBOARD_LISTEN` | `127.0.0.1` | API dashboard listen address |
| `DASHBOARD_LISTEN_PORT` | `23333` | API dashboard listen port |
| `WAIT_DECRYPT` | `0` | Wait for storage decryption before starting |
| `UPDATE_CONFIG` | `1` | Run subsing to update config before starting (set `0` to skip) |
| `SUBSING_ARGS` | `--skip-existing ./template ./workdir` | Arguments passed to `subsing` |
| `CHPST_USER` | `root:net_admin` | User and groups for `chpst` (process privilege) |
| `SINGBOX_ARGS` | `-D ./workdir` | Arguments passed to `sing-box` |

Example:

```sh
SUBSCRIPTION_URL="https://your.subscription.link"
DASHBOARD_SECRET=mysecret
DASHBOARD_LISTEN=127.0.0.1
DASHBOARD_LISTEN_PORT=23333
WAIT_DECRYPT=0
UPDATE_CONFIG=1
```

## Action Button

Click the action button in Magisk/KernelSU and use volume keys to:

- **Vol Up** — Show sing-box version
- **Vol Down** — Validate running config

## Command Line

you can control the service from a root shell instead runsvdir webui:

```sh
# Enable / Disable
sv-enable sing-box
sv-disable sing-box

# up / down / status
sv up sing-box
sv down sing-box
sv status sing-box

# View svlogd logs
tail -f /data/adb/runsvdir/log/sv/sing-box/current

# Check config
sing-box -D /data/adb/sv/sing-box/workdir check
```

## Manual Binary Update

Replace just the binary without reinstalling the entire module:

```sh
cp new-sing-box /data/adb/modules/sing-box-runsv/system/bin/sing-box
chmod +x /data/adb/modules/sing-box-runsv/system/bin/sing-box
reboot
```

## Uninstall

Uninstall the module from Magisk/KernelSU manager. This will:

1. Remove `/data/adb/runsvdir/service/sing-box` symlink
2. Remove `/data/adb/sv/sing-box` directory

Your workdir and downloaded data are preserved under `/data/adb/sv/sing-box/workdir`.

## Updating the Binary (Developers)

Use `fetch.sh` to download the latest sing-box release and bundle it into the module:

```sh
./fetch.sh       # downloads both sing-box and subsing for all architectures into bin/
./package.sh     # creates out/sing-box-runsv-<version>.zip
```

The zip can be flashed directly from Magisk/KernelSU.
