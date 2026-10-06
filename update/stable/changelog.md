## Build information

| Component | Value |
| --- | --- |
| Module | sing-box-runsv |
| Channel | stable |
| Module version | 1.14.2 |
| sing-box upstream | [v1.14.2](https://github.com/SagerNet/sing-box/releases/tag/v1.14.2) |

The module version and versionCode are derived from the upstream sing-box release.

## Variants

| Variant | Core binary location | Update note |
| --- | --- | --- |
| nomount | service folder (`/data/adb/runsvdir/service/sing-box/bin/sing-box`) | `sv restart` reloads the binary |
| mount | module `system/bin/sing-box` mounted at `/system/bin/sing-box` | reboot to mount the new binary |

Use `mount` if you want to run the core as a normal user with `chpst`;
`/data/adb` is not readable by normal users, only `/system/bin` is.

## ABI packages

| Asset suffix | Android / Magisk architecture |
| --- | --- |
| arm64-v8a | arm64 |
| armeabi-v7a | arm |
| x86_64 | x64 |
| x86 | x86 |

Each ZIP is one variant + one ABI only (assets are named `...-<variant>-<abi>.zip`). Download the asset matching the target device and the variant you want.

Requires [runsvdir-magisk](https://github.com/sorubedo/runsvdir-magisk) to be installed and rebooted first.

## SHA-256

```text
dcb0f12b1c1cbb03ff7405b72e5f319d46be966fa664e5d2820c7c13cb870f76  sing-box-runsv-1.14.2-nomount-arm64-v8a.zip
ce7e23eb5e696b0b28295db87717463130b782e989451b523599ad4141adcad1  sing-box-runsv-1.14.2-nomount-armeabi-v7a.zip
a616b8f31a5bcc2de49fd6b30c0d5de2d62bedaa310843e4702cd8279fa47265  sing-box-runsv-1.14.2-nomount-x86_64.zip
1dae78c66c2211eba13791ae085b3ea457fce40b3a5e7fc4fc19de11c424eeb5  sing-box-runsv-1.14.2-nomount-x86.zip
a41ca619163841742acef7b07ab4d9b37d8191909b94bbc99550d8af92f205fb  sing-box-runsv-1.14.2-mount-arm64-v8a.zip
722f1ef2671db61fdeb7541b1ea87e871eb0e7e28a985ebbfa19845b47a7dca3  sing-box-runsv-1.14.2-mount-armeabi-v7a.zip
6fc7bcb1dc78c07733b72a15ec69ade804c8a9944152a6bbc54bb68982950109  sing-box-runsv-1.14.2-mount-x86_64.zip
83b61a6ec99c56b7079b6f49d161e8597df6415814f486cbcf766f424d9d9a2e  sing-box-runsv-1.14.2-mount-x86.zip
```
