#!/system/bin/sh

SVC_DIR=/data/adb/sv/sing-box

ui_print() {
    echo "$1"
}

vol_sel() {
    ui_print ""
    ui_print "- Vol Up   = Show version"
    ui_print "- Vol Down = Validate config"
    ui_print ""

    while true; do
        event="$(timeout 3 /system/bin/getevent -lqc 1 2>/dev/null)"
        if echo "$event" | grep -q "KEY_VOLUMEUP"; then
            return 0
        elif echo "$event" | grep -q "KEY_VOLUMEDOWN"; then
            return 1
        fi
    done
}

ui_print "=================================="
ui_print "  sing-box-runsv"
ui_print "=================================="

if vol_sel; then
    ui_print "=> sing-box version:"
    ui_print ""
    sing-box version 2>/dev/null || ui_print "  sing-box not found"
else
    ui_print "=> Validating config..."
    ui_print ""
    if [ -d "$SVC_DIR" ]; then
        cd "$SVC_DIR"
        [ -r ./conf ] && . ./conf
        sing-box ${SINGBOX_ARGS:--D ./workdir} check 2>&1 || true
    else
        ui_print "  Service directory not found"
    fi
fi

ui_print ""
ui_print "Done."
