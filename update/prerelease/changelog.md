## Build information

| Component | Value |
| --- | --- |
| Module | sing-box-runsv |
| Channel | prerelease |
| Module version | 1.15.0-alpha.12 |
| sing-box upstream | [v1.15.0-alpha.12](https://github.com/SagerNet/sing-box/releases/tag/v1.15.0-alpha.12) |

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
b13abf17c0039232d72a45901770d9fc1453b8e6bfdb4eede71b41c5b41ab759  sing-box-runsv-1.15.0-alpha.12-nomount-arm64-v8a.zip
81cc2380ebd99de3adc9f68f34eedef0244f35032ced3efe9e66dcf852066246  sing-box-runsv-1.15.0-alpha.12-nomount-armeabi-v7a.zip
b08627a0919b3be4953657ab2ab727fbb950fd19452646bd1af51cfb3f403d30  sing-box-runsv-1.15.0-alpha.12-nomount-x86_64.zip
bd2b4fc4de5ed7b1132f94dd75d9ecc340fef0232f81bbaf35fd2205b3d2ddae  sing-box-runsv-1.15.0-alpha.12-nomount-x86.zip
51703ae16437f3ba9e4560026724383dc0e8fa4e87f9a2234165b94a9c7204c4  sing-box-runsv-1.15.0-alpha.12-mount-arm64-v8a.zip
5d299977712fbfb20f931957406207d8f61cdf37b98213e9edb2794f084421ed  sing-box-runsv-1.15.0-alpha.12-mount-armeabi-v7a.zip
24d6da844a3f58ba3e8a5a69c1ba8dab1b6f2481aa86ea46de5450dcbb392f56  sing-box-runsv-1.15.0-alpha.12-mount-x86_64.zip
34f16cc1cfbf568f825d462a9e61b9ee06647dc4924eb63b7b60561905259a08  sing-box-runsv-1.15.0-alpha.12-mount-x86.zip
```
