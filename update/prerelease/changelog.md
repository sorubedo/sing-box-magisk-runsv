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
00428e6d7781c420821799ba0dc722384114135325482cdc8a087bff9513539b  sing-box-runsv-1.15.0-alpha.10-nomount-arm64-v8a.zip
fbc8f2ee623d004bc274e5293be1c505edcc1ce51a8622e44f8522a579a5b7fd  sing-box-runsv-1.15.0-alpha.10-nomount-armeabi-v7a.zip
39a8dcd30e23d739a74f78a540be9771cb66166fb703f1f5f6803bd8362bbbf0  sing-box-runsv-1.15.0-alpha.10-nomount-x86_64.zip
30734266d82d174a6ad5b866f95d34fac7a2c5625e5c3ce025572d3c47237740  sing-box-runsv-1.15.0-alpha.10-nomount-x86.zip
38073cbc1fd38f18a764d0411272495a597ada6face229144fc92bcec3aa7e54  sing-box-runsv-1.15.0-alpha.10-mount-arm64-v8a.zip
dc6a2a73a5d1809f26d65b11f67bce016ba10fa6293ed50a1c94f0f5f79e195b  sing-box-runsv-1.15.0-alpha.10-mount-armeabi-v7a.zip
9076209ca057621ef37e29f6fee6b834da1ba4c104c47b760225e2cbdea66bed  sing-box-runsv-1.15.0-alpha.10-mount-x86_64.zip
a2de553ac73c591ed7d6c18cc5aaa3117d8d0550cacfe2788db54ec6887e47c4  sing-box-runsv-1.15.0-alpha.10-mount-x86.zip
```
