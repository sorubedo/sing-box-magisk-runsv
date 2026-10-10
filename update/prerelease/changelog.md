## Build information

| Component | Value |
| --- | --- |
| Module | sing-box-runsv |
| Channel | prerelease |
| Module version | 1.15.0-alpha.11 |
| sing-box upstream | [v1.15.0-alpha.11](https://github.com/SagerNet/sing-box/releases/tag/v1.15.0-alpha.11) |

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
9d172f033fa15881b533b9caba6878e8b06a6da52c288a5205d96e04e3840f14  sing-box-runsv-1.15.0-alpha.11-nomount-arm64-v8a.zip
8e4e1ddcbf897859340b30962ce68248e0ac51a4a0befca1c1de4d65121c2560  sing-box-runsv-1.15.0-alpha.11-nomount-armeabi-v7a.zip
6d00f8bbb0e34d95dd6655a63b50ea1d91bfa88f1e5503d48ec19412693228fb  sing-box-runsv-1.15.0-alpha.11-nomount-x86_64.zip
4203819f154e0249e3528d48bfc1876e586c0afa95528749836f963ffc855907  sing-box-runsv-1.15.0-alpha.11-nomount-x86.zip
daf0fc8d36db4ebe6fd828498188157f7d9f6ace3c81bc6c7277d58f43653ac2  sing-box-runsv-1.15.0-alpha.11-mount-arm64-v8a.zip
982a2a27593c47424727cf6aa9b95cedc335d16f3201c914c484577373984607  sing-box-runsv-1.15.0-alpha.11-mount-armeabi-v7a.zip
5efa6d580957934ef630e89ec5495e937283474d05fd3774753841e2f9bc04b9  sing-box-runsv-1.15.0-alpha.11-mount-x86_64.zip
a0ece3167aadb2ca187fa70b6c9c188d744a3d98e07381d66420524a24cfea8c  sing-box-runsv-1.15.0-alpha.11-mount-x86.zip
```
