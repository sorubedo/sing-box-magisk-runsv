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
75f6c8157d6f474f72501ca0663503df4f46298a0f171ff7bc587c5d672d10e8  sing-box-runsv-1.14.2-nomount-arm64-v8a.zip
9b4886f9619d00d80413cadca96d4e9c30e8b3090b70775a2f03c982330e5cc4  sing-box-runsv-1.14.2-nomount-armeabi-v7a.zip
de631c13c2e4e6b58bb1e9238c73cd546e8a8131ce8788498460e51ccb7ac30c  sing-box-runsv-1.14.2-nomount-x86_64.zip
7dca1523862eedbbd7d080f33fe5235d4bdf10f59238f77e416fd6247c4da3b2  sing-box-runsv-1.14.2-nomount-x86.zip
52d464da06e9c33003f81cbcd407f932b038ecd534362aaf11b4d1c7d8dfcb4e  sing-box-runsv-1.14.2-mount-arm64-v8a.zip
326697789760a68dd512c076ace6a0bdbcf20e482c37b7638d181fe5b569b267  sing-box-runsv-1.14.2-mount-armeabi-v7a.zip
fb94a245ab6f38401b9bedf36dda1a0ac1011752ee652c7f2837986dadff5fd5  sing-box-runsv-1.14.2-mount-x86_64.zip
ffe22e31fc1446d63ba3bd8e8cab62a091fb84be5c5f15b96bb7257679bcf91f  sing-box-runsv-1.14.2-mount-x86.zip
```
