# sing-box-runsv

[English](README.md) | [中文](README_zh-CN.md)

Run [sing-box](https://github.com/SagerNet/sing-box) as an autostart runsv service on Magisk / KernelSU / APatch.

The version follows the official sing-box version. There are two release channels, **Release** (stable) and **Pre-release** (test), and each channel is published in two variants, **nomount** and **mount**.

## Variants: nomount vs mount

| | `nomount` | `mount` |
| --- | --- | --- |
| Core binary | `.../service/sing-box/bin/sing-box` (service folder) | module `system/bin/sing-box`, mounted at `/system/bin/sing-box` |
| Mounts anything? | no | yes, ships the core into `/system/bin` |
| Apply a new core | `sv restart` reloads it | reboot (the new mount only appears after a reboot) |
| Drop privileges with `chpst` | no, runs as root | optional |

## Install

1. Install [runsvdir-magisk](https://github.com/sorubedo/runsvdir-magisk) first, then reboot.
2. Flash this module. Pick the ABI for your device (`arm64-v8a` for most phones) and the variant you want (`nomount` or `mount`), then reboot.
3. Put your config at `/data/adb/runsvdir/service/sing-box/workdir/config.json`.

> Without runsvdir-magisk the installer stops and tells you what is missing.

## Start

Nothing starts by itself on a fresh install. Tap the module **action** button (Volume Down to move, Volume Up to run) and pick "start + enable". Or use the shell:

```sh
SVC=/data/adb/runsvdir/service/sing-box

SVDIR=/data/adb/runsvdir/service sv-enable sing-box   # start + autostart
SVDIR=/data/adb/runsvdir/service sv-disable sing-box  # stop + no autostart
sv up $SVC        # start this time
sv down $SVC      # stop this time
sv restart $SVC   # restart the service (reloads the config)
sv status $SVC    # status
tail -f /data/adb/runsvdir/log/sv/sing-box/current    # logs
```

## Update

Flash the newer package over the old one; your config and autostart setting are kept. If you edited `run` / `log/run` / `conf`, the installer asks with the volume keys: Volume Up updates the binary only, Volume Down also updates the scripts (`run`, `log/run`, `conf`).

- `nomount`: restart the service afterwards — `sv restart /data/adb/runsvdir/service/sing-box`.
- `mount`: **reboot** afterwards; the new core is mounted from `/system/bin` only after a reboot.

The manager can also check for updates by itself; switch between the **stable** and **prerelease** channel (and keep the current variant) from the module action menu.

## Uninstall

This removes the whole service folder, including your config. Back it up first.

## FAQ

- **Installer says runsvdir-magisk is missing**: install runsvdir-magisk, reboot, then flash this module.
- **Service is not running**: check the log, or use "validate config" in the action menu.
- **Want the config under /sdcard**: edit `conf` in the service folder, point `SINGBOX_ARGS` at your folder, and set `WAIT_DECRYPT=1`.
- **Want to run the core as a normal user**: use the `mount` variant, then set `RUN_AS` in `conf` to that user.
