## Build information

| Component | Value |
| --- | --- |
| Module | sing-box-runsv |
| Channel | stable |
| Module version | 1.14.4 |
| sing-box upstream | [v1.14.4](https://github.com/SagerNet/sing-box/releases/tag/v1.14.4) |

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
57fdc8210f7004fb7efa866116070aa914dc8ffc922efc88cdb8902465b548d5  sing-box-runsv-1.14.4-nomount-arm64-v8a.zip
2b4e5eb8c7a4e279ba42f3883402f2c022ef974ae9f1ce9bca39871eb5117c8f  sing-box-runsv-1.14.4-nomount-armeabi-v7a.zip
67f34bff3ceaf04bb9d534c9a7c40db65fdb45355eb436be8517ff445c14ab94  sing-box-runsv-1.14.4-nomount-x86_64.zip
0529932c29ce754623ba3ad3ba191782ee88be35e73caabc6a16238f63ab08c4  sing-box-runsv-1.14.4-nomount-x86.zip
de084de45ec0dec5271e70d0ced28b870bc8bf5490a16920462f3a7731768d69  sing-box-runsv-1.14.4-mount-arm64-v8a.zip
bf414d045617def0bd94cbff4e3b752cc1b5250903d122f244a2b573b1b2f20e  sing-box-runsv-1.14.4-mount-armeabi-v7a.zip
0cbf708e5e13d406dbbe6471e053e8a643dea20ed5afb327e9500f508fdb85b4  sing-box-runsv-1.14.4-mount-x86_64.zip
79c9bb47a3e81ad2fd413801ade415aa71c49f078f5432b957a3dc8c8b8ab07e  sing-box-runsv-1.14.4-mount-x86.zip
```
