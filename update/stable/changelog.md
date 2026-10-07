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
499d04b5deb4b60b5cbf3f58a4bd5ff74c262e760d346c5f60161b53d55c682f  sing-box-runsv-1.14.2-nomount-arm64-v8a.zip
005dba4982161ce7184a80826bdbb682abcda43ebbeefd7698137971ae6df3c5  sing-box-runsv-1.14.2-nomount-armeabi-v7a.zip
0bed374c49f791aa30348b2943d8ff66b9017cc7a2494f4a065d775b094ab699  sing-box-runsv-1.14.2-nomount-x86_64.zip
fd04e8908eec561f0d18ca17cc4507687b422d0218b498694afd56dc23610358  sing-box-runsv-1.14.2-nomount-x86.zip
005750fe3d6d178987f2a379bf24396340b925b20d4833f84d152c0b262cc9e0  sing-box-runsv-1.14.2-mount-arm64-v8a.zip
5d669917154bb79a3cbb1751e5b38e8460a45c05eeb777de144e7a0cb21a0db7  sing-box-runsv-1.14.2-mount-armeabi-v7a.zip
ba27ad58a29f0b39da5548e411fb46d338425c8c0e5b2579885e6aceca8fd415  sing-box-runsv-1.14.2-mount-x86_64.zip
efdadc2c6d36ccdb0233d46342373645ac4f1634b4720f2056ce722b862eed45  sing-box-runsv-1.14.2-mount-x86.zip
```
