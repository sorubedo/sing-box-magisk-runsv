#!/system/bin/sh
#
# sing-box (runsv) installer
#
#  * requires runsvdir-magisk (services live in /data/adb/runsvdir/service/)
#  * installs the sing-box binary into the service folder (nothing is mounted)
#  * never overwrites an existing service definition
#

SVDIR=/data/adb/runsvdir/service
SVC="$SVDIR/sing-box"
DEP_URL="https://github.com/sorubedo/runsvdir-magisk"

banner() {
    ui_print "=============================================="
    ui_print "            sing-box (runsv)"
    ui_print "=============================================="
}

abort_missing_dep() {
    ui_print ""
    ui_print "############################################################"
    ui_print "#                                                          #"
    ui_print "#   安装中止：缺少依赖 runsvdir-magisk                      #"
    ui_print "#                                                          #"
    ui_print "#   请先安装并重启 runsvdir-magisk，确认以下目录存在：      #"
    ui_print "#     $SVDIR"
    ui_print "#                                                          #"
    ui_print "#   下载地址：                                              #"
    ui_print "#     $DEP_URL"
    ui_print "#                                                          #"
    ui_print "############################################################"
    ui_print ""
    abort "! Installation aborted: runsvdir-magisk is missing or inactive"
}

runsvdir_module_ok() {
    local root
    for root in /data/adb/modules /data/adb/lite_modules; do
        if [ -d "$root/runsvdir" ] \
            && [ ! -e "$root/runsvdir/remove" ] \
            && [ ! -e "$root/runsvdir/disable" ]; then
            return 0
        fi
    done
    return 1
}

# Update choice, picked with the volume keys. Defaults to binary only so that
# software-flashed installs (no getevent / no key press) never hang.
GETEVENT=/system/bin/getevent
[ -x "$GETEVENT" ] || GETEVENT="$(command -v getevent 2>/dev/null)"
UPDATE_MODE=binary

choose_update_mode() {
    if [ -z "$GETEVENT" ]; then
        ui_print "- 未找到 getevent，按默认方式仅更新二进制"
        return 0
    fi

    ui_print ""
    ui_print "=============================================="
    ui_print "  检测到已安装，请选择更新方式"
    ui_print "=============================================="
    ui_print "  音量上 : 仅更新 sing-box 二进制"
    ui_print "           （保留你修改过的 run / log/run）"
    ui_print "  音量下 : 同时更新 run 和 log/run"
    ui_print "  30 秒内未选择则默认仅更新二进制"
    ui_print ""

    i=0
    while [ "$i" -lt 6 ]; do
        ev="$(timeout 5 "$GETEVENT" -lqc 1 2>/dev/null)"
        case "$ev" in
            *KEY_VOLUMEUP*DOWN*)
                UPDATE_MODE=binary
                ui_print "- 已选择：仅更新二进制"
                return 0
                ;;
            *KEY_VOLUMEDOWN*DOWN*)
                UPDATE_MODE=scripts
                ui_print "- 已选择：同时更新 run 和 log/run"
                return 0
                ;;
        esac
        i=$((i + 1))
    done

    ui_print "- 超时未选择，按默认方式仅更新二进制"
    return 0
}

case "$ARCH" in
    arm64) ABI=arm64-v8a ;;
    arm)   ABI=armeabi-v7a ;;
    x64)   ABI=x86_64 ;;
    x86)   ABI=x86 ;;
    *)
        ui_print "! Unsupported architecture: $ARCH"
        abort "! Aborting installation"
        ;;
esac

if [ ! -f "$MODPATH/bin/$ABI/sing-box" ]; then
    ui_print "! Wrong package: this ZIP does not contain the $ABI sing-box binary"
    abort "! Please download the $ABI build for this device"
fi

banner
ui_print "- 设备架构: $ARCH ($ABI)"
ui_print "- 检查依赖: runsvdir-magisk"

runsvdir_module_ok || abort_missing_dep
[ -d "$SVDIR" ] || abort_missing_dep

ui_print "- 依赖检查通过"
ui_print ""

UPDATE=0
[ -d "$SVC" ] && UPDATE=1

if [ "$UPDATE" -eq 1 ]; then
    choose_update_mode
fi

# --- install / update the binary --------------------------------------
# Copy to a temp name and rename, so a running service keeps its old inode
# and the new binary takes effect on the next "sv restart".
mkdir -p "$SVC/bin"
cp -f "$MODPATH/bin/$ABI/sing-box" "$SVC/bin/.sing-box.new"
chmod 0755 "$SVC/bin/.sing-box.new"
chown 0:0 "$SVC/bin/.sing-box.new" 2>/dev/null
mv -f "$SVC/bin/.sing-box.new" "$SVC/bin/sing-box"

# --- fresh install: create the service definition ---------------------
if [ "$UPDATE" -eq 0 ]; then
    mkdir -p "$SVC/log" "$SVC/workdir"
    cp -f "$MODPATH/service/sing-box/run" "$SVC/run"
    cp -f "$MODPATH/service/sing-box/finish" "$SVC/finish"
    cp -f "$MODPATH/service/sing-box/log/run" "$SVC/log/run"
    chmod 0755 "$SVC/run" "$SVC/finish" "$SVC/log/run"
    chown 0:0 "$SVC/run" "$SVC/finish" "$SVC/log/run" 2>/dev/null
    # Fresh install is disabled by default: runsv will not autostart it.
    touch "$SVC/down"
elif [ "$UPDATE_MODE" = "scripts" ]; then
    mkdir -p "$SVC/log"
    cp -f "$MODPATH/service/sing-box/run" "$SVC/run"
    cp -f "$MODPATH/service/sing-box/log/run" "$SVC/log/run"
    chmod 0755 "$SVC/run" "$SVC/log/run"
    chown 0:0 "$SVC/run" "$SVC/log/run" 2>/dev/null
fi

rm -rf "$MODPATH/bin" "$MODPATH/service"

# --- messages ---------------------------------------------------------
if [ "$UPDATE" -eq 1 ]; then
    ui_print "=============================================="
    if [ "$UPDATE_MODE" = "scripts" ]; then
        ui_print "  更新完成：二进制 + run + log/run"
    else
        ui_print "  更新完成：仅 sing-box 二进制"
    fi
    ui_print "=============================================="
    if [ "$UPDATE_MODE" = "scripts" ]; then
        ui_print "  run 和 log/run 已更新"
    else
        ui_print "  现有 run / log/run 保持不变"
    fi
    ui_print ""
    ui_print "!! 更新后请重启服务以加载新二进制:"
    ui_print "   sv restart $SVC"
else
    ui_print "=============================================="
    ui_print "  首次安装完成"
    ui_print "=============================================="
    ui_print "  服务目录: $SVC"
    ui_print "  启动脚本: $SVC/run      (按需修改)"
    ui_print "  配置目录: $SVC/workdir   (放入 config.json)"
    ui_print "  当前状态: 已停用 (存在 down 文件)"
fi

ui_print ""
ui_print "----------------------------------------------------"
ui_print "  常用命令"
ui_print "----------------------------------------------------"
ui_print "  启用开机自启: rm $SVC/down"
ui_print "  停用开机自启: touch $SVC/down"
ui_print "  启动服务:     sv up $SVC"
ui_print "  停止服务:     sv down $SVC"
ui_print "  重启服务:     sv restart $SVC"
ui_print "  查看状态:     sv status $SVC"
ui_print "  启动并启用:   SVDIR=$SVDIR sv-enable sing-box"
ui_print "  停止并停用:   SVDIR=$SVDIR sv-disable sing-box"
ui_print "  查看日志:     tail -f /data/adb/runsvdir/log/sv/sing-box/current"
ui_print "----------------------------------------------------"
ui_print ""
ui_print "- 放置配置后，执行上方的启动命令或使用模块操作按钮"
