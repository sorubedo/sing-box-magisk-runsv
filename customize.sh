#!/system/bin/sh

case "$ARCH" in
    arm64)   ABI=arm64-v8a ;;
    arm)     ABI=armeabi-v7a ;;
    x64)     ABI=x86_64 ;;
    x86)     ABI=x86 ;;
    *)
        ui_print "! Unsupported architecture: $ARCH"
        abort "! Aborting installation"
        ;;
esac

ui_print "- Installing sing-box for $ARCH ($ABI)"

if [ ! -f "$MODPATH/bin/$ABI/sing-box" ] || [ ! -f "$MODPATH/bin/$ABI/subsing" ]; then
    abort "! Wrong package: download the $ABI build for this device"
fi

mkdir -p "$MODPATH/system/bin"
cp "$MODPATH/bin/$ABI/sing-box" "$MODPATH/system/bin/"
cp "$MODPATH/bin/$ABI/subsing" "$MODPATH/system/bin/"
set_perm_recursive "$MODPATH/system/bin" 0 0 0755 0755

SINGBOX_DIR=/data/adb/sv/sing-box
mkdir -p "$SINGBOX_DIR"
cp -r "$MODPATH/sv/sing-box/"* "$SINGBOX_DIR/"
mkdir -p "$SINGBOX_DIR/workdir"
set_perm_recursive "$SINGBOX_DIR" 0 0 0755 0755

rm -rf "${MODPATH:?}/bin" "${MODPATH:?}/sv"

ui_print "- sing-box installed to $SINGBOX_DIR"
ui_print "- Reboot required for Magisk to mount /system/bin/sing-box"
