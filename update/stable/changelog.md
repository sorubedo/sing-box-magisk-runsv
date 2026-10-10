## Build information

| Component | Value |
| --- | --- |
| Module | sing-box-runsv |
| Channel | stable |
| Module version | 1.14.3 |
| sing-box upstream | [v1.14.3](https://github.com/SagerNet/sing-box/releases/tag/v1.14.3) |

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
072a272dd9647bf09168410a9d8bddc9d01a9f26be1f93ad1883da06de4c5e92  sing-box-runsv-1.14.3-nomount-arm64-v8a.zip
801e9e44155b4139d81d378aca05813f40727bbdf63a65fd052513dac3ea6d4e  sing-box-runsv-1.14.3-nomount-armeabi-v7a.zip
db0fac0bcd560445c0de7422b1ff8718a81a3a68dee3631268ac9432dfa1f50f  sing-box-runsv-1.14.3-nomount-x86_64.zip
7c0e9b9435efc16908515c935eb99247bf548c1fb4fd2478ae6e2b6a81e38419  sing-box-runsv-1.14.3-nomount-x86.zip
c0af7ddd3086edd13235762028ce58815f62a0bf5956a5613d1616a3909aa16e  sing-box-runsv-1.14.3-mount-arm64-v8a.zip
87be3f6caf168b136b40e9b2793a7a1f39e1e181487cb115493b1b21b526f7ca  sing-box-runsv-1.14.3-mount-armeabi-v7a.zip
d6e57f568e76a65fd9d31c4ca018925a5680a1215737f675c910f8df639ad5b7  sing-box-runsv-1.14.3-mount-x86_64.zip
86670dd71fe4b925971466563536a2132636d84c5d985366e237d38ea6f88e1f  sing-box-runsv-1.14.3-mount-x86.zip
```
