## Build information

| Component | Value |
| --- | --- |
| Module | sing-box-runsv |
| Channel | prerelease |
| Module version | 1.15.0-alpha.10 |
| sing-box upstream | [v1.15.0-alpha.10](https://github.com/SagerNet/sing-box/releases/tag/v1.15.0-alpha.10) |

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
8a5033cc12c1c39f6351d28fa54af829c9e4afd64d83c0d9c1dcb8b2cb1f8128  sing-box-runsv-1.15.0-alpha.10-nomount-arm64-v8a.zip
c0a49cf8c683bb1d4f146a061731f0518115f138b4569ac8c1c306b6b76dcae7  sing-box-runsv-1.15.0-alpha.10-nomount-armeabi-v7a.zip
2d3ba2a3ef06d823b5cb0bf7a62f5e06c0fe114272c722945e631da2c5c2f862  sing-box-runsv-1.15.0-alpha.10-nomount-x86_64.zip
1badc83553a28f5b9f98e23661b4a1a2b6533dc4be31cde770adb4491cc68de1  sing-box-runsv-1.15.0-alpha.10-nomount-x86.zip
452387bbe5095d87c1436278623c79341d86197acc6a2df40c66c55c96f1e327  sing-box-runsv-1.15.0-alpha.10-mount-arm64-v8a.zip
dd98e2799d7c43d6dea8e1691219897bad100c705f0f8b46c6bbfe84a23317aa  sing-box-runsv-1.15.0-alpha.10-mount-armeabi-v7a.zip
aadc4eecfc99d955baf3e3e54316f2990d5fb7b79fd401ce1fa3fa41fc495d52  sing-box-runsv-1.15.0-alpha.10-mount-x86_64.zip
370097f917caac35fd76ceaf1150bcc9152661de1460612491f61dfc7359f3ac  sing-box-runsv-1.15.0-alpha.10-mount-x86.zip
```
