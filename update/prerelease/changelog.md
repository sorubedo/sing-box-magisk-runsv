## Build information

| Component | Value |
| --- | --- |
| Module | sing-box-runsv |
| Channel | prerelease |
| Module version | 1.15.0-alpha.13 |
| sing-box upstream | [v1.15.0-alpha.13](https://github.com/SagerNet/sing-box/releases/tag/v1.15.0-alpha.13) |

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
9b67c4426a21a5b532ce92366a54ad3919889e4eead3d45bd2c258f4d764567d  sing-box-runsv-1.15.0-alpha.13-nomount-arm64-v8a.zip
3c7ad88c8880a5fda90a8a81d6fb4d0b692e9375c8bcdf88e092a044cb327d81  sing-box-runsv-1.15.0-alpha.13-nomount-armeabi-v7a.zip
ef40b8d3cf6e606a301169f0bc39dae83bf07d7663793ad34f7b37c91bb98afc  sing-box-runsv-1.15.0-alpha.13-nomount-x86_64.zip
af3d99a4b4a166c272c0914d4a470bf741a087378ef1a255f2f31eb7f182f2e3  sing-box-runsv-1.15.0-alpha.13-nomount-x86.zip
29e6d4ecb8ada16289b731dfbf26cc107f7060bf406778ca089eb3d66a1a2a14  sing-box-runsv-1.15.0-alpha.13-mount-arm64-v8a.zip
a9543fb5956f804a9dcbbdde690ade7c3500cc40e718a3ebbe138109d028e7ee  sing-box-runsv-1.15.0-alpha.13-mount-armeabi-v7a.zip
9beb8e1bc0a161c1f488146528284a6588da78132aaff51faba42efa8d840048  sing-box-runsv-1.15.0-alpha.13-mount-x86_64.zip
27a0529582776353748a2a39dc17a81c39e44f6ddd7f535931527cb6daffb281  sing-box-runsv-1.15.0-alpha.13-mount-x86.zip
```
