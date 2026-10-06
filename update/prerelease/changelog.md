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
98d27e2cb1a7f1ed14152d2014e96e0efabc5d677f4e7b1a11f1f621183ed5b8  sing-box-runsv-1.15.0-alpha.10-nomount-arm64-v8a.zip
5b23fc36681ad48bb15d63cb43f96deb48fcf9bd8ae5f8435baf6c868726a830  sing-box-runsv-1.15.0-alpha.10-nomount-armeabi-v7a.zip
f01af31a0a200119df261978e5b07141b7c7100143a81cca181f1c6f909012a2  sing-box-runsv-1.15.0-alpha.10-nomount-x86_64.zip
e30307ab37b1d214d4b5c2338a8fe0684f31c170c68d86c9665079f44309c45b  sing-box-runsv-1.15.0-alpha.10-nomount-x86.zip
8971bc33ebf03dfd43c8802cc93fa2235079cb5c7a8d289d293d851413b85eba  sing-box-runsv-1.15.0-alpha.10-mount-arm64-v8a.zip
204f8b8aec8003685e14431304ab395b57efa46a0b2fc33b88e593861514f338  sing-box-runsv-1.15.0-alpha.10-mount-armeabi-v7a.zip
f012c9e3d8d04260e3249e3fcd13e2c4f3cc2ab328c0ee9533f5db487d60842d  sing-box-runsv-1.15.0-alpha.10-mount-x86_64.zip
e169bbb5fcf419298b528cb15078924babd58b0a33a18f942bdbc67a911a9de7  sing-box-runsv-1.15.0-alpha.10-mount-x86.zip
```
