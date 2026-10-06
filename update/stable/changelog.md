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

Use `mount` if you want to run the core as a normal user with `setuidgid`;
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
fad712c48671c75022de0b0d01e490ef2083b7afce6a8a7c99599311e703981b  sing-box-runsv-1.14.2-nomount-arm64-v8a.zip
d80547d8f176a3a4ac6298bb3662dda0e766f91d3f6b494bba0717204bbd58d1  sing-box-runsv-1.14.2-nomount-armeabi-v7a.zip
3c2e2a84215d82cf914a612df79fa55b1067b37db92ee5cfef7704c700ff03e6  sing-box-runsv-1.14.2-nomount-x86_64.zip
359a889c5f043237a0eaed0034f04b5101787d2d56ce4b33c1859e0cde30bd2d  sing-box-runsv-1.14.2-nomount-x86.zip
98421576f0dc298a970e0c056beefd9656512239bdbf1a5fa8e7379832a7664b  sing-box-runsv-1.14.2-mount-arm64-v8a.zip
7ee9cb72216a0b3b32323431ed4ff502d1d0a9825d0da48bb32b504b5cfef737  sing-box-runsv-1.14.2-mount-armeabi-v7a.zip
2d1359a57528d28e52d7690285cbc26b35de0322604cdeb126b1d6a653d9c4c4  sing-box-runsv-1.14.2-mount-x86_64.zip
da482be0393376eabe4429812ae9c091c6b6b42788e64112b026176a8d31c7db  sing-box-runsv-1.14.2-mount-x86.zip
```
