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

## Download

Release attachments are **not** kept in sync with upstream sing-box versions.
Use GitHub Actions to get the latest build:

1. Go to the [Build Workflow](https://github.com/sorubedo/sing-box-magisk-runsv/actions/workflows/build.yml)
2. Click **Run workflow** → **Run workflow**
3. Wait for the run to finish, then download the artifact and select the ZIP whose suffix matches your device: `arm64-v8a`, `armeabi-v7a`, `x86_64`, or `x86`

## Installation

1. Install `runsvdir-magisk` first, then install this module in Magisk/KernelSU.
2. **Reboot** your device.
3. Copy `/data/adb/sv/sing-box/conf.example` to `/data/adb/sv/sing-box/conf` and edit it (required if using subsing; optional if you already placed your own `config.json` in `workdir/`).
4. Symlink `sing-box` from the runsvdir WebUI or run `ln -s /data/adb/sv/sing-box /data/adb/runsvdir/service/` in a root shell.

## Configuration

Create `/data/adb/sv/sing-box/conf` to customize the service. All variables are optional.

A built-in template config (`template/config.json`) is included as a starting point. **It may not suit everyone** — consider placing your own `config.json` directly into `workdir/` and setting `UPDATE_CONFIG=0` to skip subsing.

### Template Config Variables

These variables are specific to the built-in template. They have no effect if you use your own `config.json`.

| Variable | Example | Description |
|---|---|---|
| `SUBSCRIPTION_URL` | — | Remote subscription URL for proxy nodes (mihomo format) |
| `DASHBOARD_SECRET` | — | API dashboard authentication secret |
| `DASHBOARD_LISTEN` | — | API dashboard listen address |
| `DASHBOARD_LISTEN_PORT` | — | API dashboard listen port |

### Service Variables

| Variable | Default | Description |
|---|---|---|
| `WAIT_DECRYPT` | `0` | Wait for storage decryption before starting |
| `UPDATE_CONFIG` | `1` | Run subsing before start (set `0` to skip) |
| `SUBSING_ARGS` | `--skip-existing ./template ./workdir` | Arguments passed to `subsing` |
| `CHPST_USER` | `root:net_admin` | User and groups for `chpst` (process privilege) |
| `SINGBOX_ARGS` | `-D ./workdir` | Arguments passed to `sing-box` |

### About subsing

`subsing` is bundled for convenience — it generates `workdir/config.json` from `template/config.json` and your `SUBSCRIPTION_URL`. **It is not required.** If you already have your own config, simply place it at `/data/adb/sv/sing-box/workdir/config.json` and set `UPDATE_CONFIG=0`.

Under the default `SUBSING_ARGS` (`--skip-existing`), subsing runs at most once: it generates the config only if `workdir/config.json` does not already exist. This means:

- **Manual config users** — put your `config.json` in `workdir/`, subsing skips it (0 runs).
- **First boot with the template** — subsing generates the config once (1 run).
- **Subsequent boots** — config already exists, subsing skips it.

If you want subsing to re-fetch and overwrite the config on every boot, remove `--skip-existing` from `SUBSING_ARGS`:

```sh
SUBSING_ARGS="./template ./workdir"
```

**Caveat:** `runsvdir` starts very early in the boot process, possibly before the network is available. When subsing fails due to no network, the service exits with a 10-second delay, and `runsv` automatically retries until it succeeds.

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
2. Remove `/data/adb/sv/sing-box` directory (including `workdir/` and all cached data)

To keep your config, rule sets, and cache across reinstalls, point `SUBSING_ARGS` and `SINGBOX_ARGS` to a directory outside `/data/adb/sv/sing-box/`, e.g. under `/storage/emulated/0/`:

```sh
SINGBOX_ARGS="-D /storage/emulated/0/sing-box"
SUBSING_ARGS="--skip-existing ./template /storage/emulated/0/sing-box"
```

If the target is on `/storage/emulated/0/`, you must set `WAIT_DECRYPT=1` — most ROMs encrypt `/data`, and the media storage won't be available until the device is first unlocked after boot. The service will delay startup until then. If your ROM does not encrypt by default, `WAIT_DECRYPT` is unnecessary.

## Updating the Binary (Developers)

Use `fetch.sh` to download the latest sing-box release and bundle it into the module:

```sh
./fetch.sh       # downloads both sing-box and subsing for all architectures into bin/
./package.sh     # creates one out/sing-box-runsv-<version>-<abi>.zip per ABI
```

Each ZIP contains only one ABI and can be flashed directly from Magisk/KernelSU. Pass one or more ABI names to `package.sh` to build only those targets.
