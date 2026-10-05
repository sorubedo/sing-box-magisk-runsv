# sing-box-runsv

[English](README.md) | [中文](README_zh-CN.md)

Run [sing-box](https://github.com/SagerNet/sing-box) as an autostart runsv service on Magisk / KernelSU / APatch.

The version follows the official sing-box version. Two download channels: **Release** (stable) and **Pre-release** (test).

## Install

1. Install [runsvdir-magisk](https://github.com/sorubedo/runsvdir-magisk) first, then reboot.
2. Flash this module (`arm64-v8a` for most phones), then reboot.
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
sv restart $SVC   # restart
sv status $SVC    # status
tail -f /data/adb/runsvdir/log/sv/sing-box/current    # logs
```

## Update

Flash the newer package over the old one; your config and autostart setting are kept. If you edited `run` / `log/run`, the installer asks with the volume keys: Volume Up updates the binary only, Volume Down also updates the scripts. Restart the service afterwards:

```sh
sv restart /data/adb/runsvdir/service/sing-box
```

## Uninstall

This removes the whole service folder, including your config. Back it up first.

## FAQ

- **Installer says runsvdir-magisk is missing**: install runsvdir-magisk, reboot, then flash this module.
- **Service is not running**: check the log, or use "validate config" in the action menu.
- **Want the config under /sdcard**: edit `run` in the service folder, point `SINGBOX_ARGS` at your folder, and set `WAIT_DECRYPT=1`.
