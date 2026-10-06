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
8883f25979fe55d8a3121ab41ff2b98dda5b2c9bd49cfea18c74c69ae5ebf1c1  sing-box-runsv-1.15.0-alpha.10-nomount-arm64-v8a.zip
ffb8dc4fe91682b7c1dc18aec504e60c9eb4a5bce3692fb2245eef007623fb11  sing-box-runsv-1.15.0-alpha.10-nomount-armeabi-v7a.zip
ead23d2860eb3f50587d984624c91fa8479a75933da2b6176da01d69e4548c6b  sing-box-runsv-1.15.0-alpha.10-nomount-x86_64.zip
4122e78a0fe3f56ef263b414a9869ca3be8af4dc275e872239ce48d2a904ccbe  sing-box-runsv-1.15.0-alpha.10-nomount-x86.zip
1089a4dcfe9f8b65372cf540e8adc602ca15b8c1c81cb693f861424231eb1e94  sing-box-runsv-1.15.0-alpha.10-mount-arm64-v8a.zip
28cfb7f54ed9dff288864423d0f2d45d8455a6c07bda80dee2f3693cadb578b3  sing-box-runsv-1.15.0-alpha.10-mount-armeabi-v7a.zip
a9a64837431d09f54858b0235c317834ef531f04a6c11e8b85fea80cc4b43f52  sing-box-runsv-1.15.0-alpha.10-mount-x86_64.zip
6f0261791aefdb81784e211f50c5e6bff7e51b10fdfb90df35fb8d1c303f50b3  sing-box-runsv-1.15.0-alpha.10-mount-x86.zip
```
