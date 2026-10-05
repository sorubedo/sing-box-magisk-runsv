#!/system/bin/sh
#
# sing-box (runsv) action button.
#
# Volume Down = move to the next entry
# Volume Up   = run the highlighted entry
#
# After an entry has run, the menu is shown again so several actions can be
# performed in one go; pick "结束" to leave.
#

SVDIR=/data/adb/runsvdir/service
SVC="$SVDIR/sing-box"
BIN="$SVC/bin/sing-box"

# Module directory: action.sh is executed from inside the module folder, so
# ${0%/*} resolves to /data/adb/modules/sing-box-runsv.
MODDIR="${0%/*}"
[ -d "$MODDIR" ] || MODDIR="/data/adb/modules/sing-box-runsv"
MODPROP="$MODDIR/module.prop"

# Must match the base used by package.sh / publish-update.sh.
RAW_BASE="${SING_BOX_UPDATE_BASE:-https://raw.githubusercontent.com/sorubedo/sing-box-magisk-runsv/main}"

export SVDIR

say() { echo "$1"; }

# --- update channel helpers -------------------------------------------

current_channel() {
    ch="$(sed -n 's|^updateJson=.*/update/\([^/]*\)/[^/]*\.json$|\1|p' "$MODPROP" 2>/dev/null | head -n 1)"
    if [ -z "$ch" ] && [ -f "$MODDIR/build-info.prop" ]; then
        ch="$(sed -n 's|^moduleChannel=||p' "$MODDIR/build-info.prop" 2>/dev/null | head -n 1)"
    fi
    case "$ch" in
        stable | prerelease) echo "$ch" ;;
        *) echo "" ;;
    esac
}

current_abi() {
    abi="$(sed -n 's|^updateJson=.*/\([^/]*\)\.json$|\1|p' "$MODPROP" 2>/dev/null | head -n 1)"
    if [ -z "$abi" ] && [ -f "$MODDIR/build-info.prop" ]; then
        abi="$(sed -n 's|^targetAbi=||p' "$MODDIR/build-info.prop" 2>/dev/null | head -n 1)"
    fi
    echo "$abi"
}

channel_label() {
    case "$1" in
        stable) echo "稳定版" ;;
        prerelease) echo "预发布版" ;;
        *) echo "未设置" ;;
    esac
}

# Rewrite updateJson in the installed module.prop. Magisk / KernelSU / APatch
# read module.prop on every module list load, so this takes effect immediately.
set_channel() {
    new_ch="$1"
    abi="$(current_abi)"
    if [ -z "$abi" ]; then
        return 1
    fi
    url="$RAW_BASE/update/$new_ch/$abi.json"
    tmp="$MODPROP.tmp"
    if grep -q '^updateJson=' "$MODPROP" 2>/dev/null; then
        sed "s|^updateJson=.*|updateJson=$url|" "$MODPROP" > "$tmp"
    else
        cp "$MODPROP" "$tmp"
        printf 'updateJson=%s\n' "$url" >> "$tmp"
    fi
    # Overwrite in place so ownership / mode / inode are preserved.
    cat "$tmp" > "$MODPROP"
    rm -f "$tmp"
    return 0
}

GETEVENT=/system/bin/getevent
if [ ! -x "$GETEVENT" ]; then
    say "! 找不到 getevent，无法使用音量键菜单"
    exit 1
fi

if [ -x /system/bin/sv ]; then
    SV=/system/bin/sv
elif command -v sv >/dev/null 2>&1; then
    SV=sv
else
    say "! 找不到 sv，请先安装 runsvdir-magisk 并重启设备"
    exit 1
fi

if [ -x /system/bin/sv-enable ]; then
    SV_ENABLE=/system/bin/sv-enable
    SV_DISABLE=/system/bin/sv-disable
else
    SV_ENABLE=sv-enable
    SV_DISABLE=sv-disable
fi

if [ ! -d "$SVC" ]; then
    say "! 服务目录不存在: $SVC"
    say "  请重新刷入本模块"
    exit 1
fi

if command -v timeout >/dev/null 2>&1; then
    TIMEOUT="timeout 5"
else
    TIMEOUT=""
fi

# Only key-down (value=1) events are accepted. getevent labels that value as
# DOWN, while the matching release event is labelled UP, so one physical press
# moves the cursor exactly once.
read_key() {
    while :; do
        ev="$($TIMEOUT "$GETEVENT" -lqc 1 2>/dev/null)"
        case "$ev" in
            *KEY_VOLUMEUP*DOWN*) echo up; return 0 ;;
            *KEY_VOLUMEDOWN*DOWN*) echo down; return 0 ;;
        esac
    done
}

menu_count() {
    n=0
    old_ifs="$IFS"; IFS='
'
    for line in $MENU; do n=$((n + 1)); done
    IFS="$old_ifs"
    echo "$n"
}

# menu_line <index> -> "key|label"
menu_line() {
    want="$1"; n=0
    old_ifs="$IFS"; IFS='
'
    for line in $MENU; do
        n=$((n + 1))
        if [ "$n" -eq "$want" ]; then
            IFS="$old_ifs"
            echo "$line"
            return 0
        fi
    done
    IFS="$old_ifs"
    return 1
}

menu_render() {
    sel="$1"; n=0
    old_ifs="$IFS"; IFS='
'
    for line in $MENU; do
        n=$((n + 1))
        label="${line#*|}"
        if [ "$n" -eq "$sel" ]; then
            printf '  ==> %d) %s\n' "$n" "$label"
        else
            printf '      %d) %s\n' "$n" "$label"
        fi
    done
    IFS="$old_ifs"
}

# Rebuilt on every redraw so the channel label always matches the current
# setting in module.prop.
build_menu() {
    ch="$(current_channel)"
    MENU="up|启动服务 (仅本次)
down|停止服务 (仅本次)
restart|重启服务
enable|启用开机自启 (删除 down)
disable|停用开机自启 (创建 down)
sv-enable|启动并启用
sv-disable|停止并停用
channel|切换更新渠道 (当前: $(channel_label "$ch"))
check|校验配置文件
version|查看 sing-box 版本
quit|结束"
    COUNT="$(menu_count)"
}

do_action() {
    case "$1" in
        up)         "$SV" up "$SVC" 2>&1 ;;
        down)       "$SV" down "$SVC" 2>&1 ;;
        restart)    "$SV" restart "$SVC" 2>&1 ;;
        enable)     rm -f "$SVC/down" && echo "已启用开机自启 (down 已删除)" ;;
        disable)    touch "$SVC/down" && echo "已停用开机自启 (down 已创建)" ;;
        sv-enable)  "$SV_ENABLE" sing-box 2>&1 && echo "已启动并启用" ;;
        sv-disable) "$SV_DISABLE" sing-box 2>&1 && echo "已停止并停用" ;;
        channel)
            cur="$(current_channel)"
            if [ "$cur" = "stable" ]; then
                new="prerelease"
            else
                new="stable"
            fi
            if set_channel "$new"; then
                echo "更新渠道已切换为: $(channel_label "$new")"
                echo "重新打开模块列表即可按新渠道检查更新"
            else
                echo "! 切换失败：无法确定当前架构"
                echo "  (缺少 updateJson 且读不到 build-info.prop)"
            fi
            ;;
        check)      ( cd "$SVC" && ./bin/sing-box -D ./workdir check ) 2>&1 ;;
        version)    "$BIN" version 2>&1 ;;
    esac
}

# ESC[H ESC[J = cursor home + clear to end of screen, so the menu is redrawn
# in place instead of being appended line by line.
print_frame() {
    sel="$1"
    printf '\033[H\033[J'
    echo "=============================================="
    echo "            sing-box (runsv)"
    echo "=============================================="
    echo "服务目录: $SVC"
    echo ""
    echo "当前状态:"
    "$SV" status "$SVC" 2>&1 | while IFS= read -r l; do echo "  $l"; done
    echo ""
    if [ -n "$RESULT" ]; then
        echo "上次操作: $RESULT_TITLE"
        printf '%s\n' "$RESULT" | tail -n 12 | while IFS= read -r l; do echo "  $l"; done
        echo ""
    fi
    menu_render "$sel"
    echo ""
    echo "【音量下 = 切换选项】  【音量上 = 执行选中项】"
    echo ""
}

sel=1
RESULT=""
RESULT_TITLE=""

while :; do
    build_menu
    [ "$sel" -gt "$COUNT" ] && sel=1

    print_frame "$sel"

    key="$(read_key)"
    if [ "$key" = "down" ]; then
        sel=$((sel % COUNT + 1))
        continue
    fi

    line="$(menu_line "$sel")"
    name="${line%%|*}"
    label="${line#*|}"

    if [ "$name" = "quit" ]; then
        break
    fi

    out="$(do_action "$name")"
    [ -n "$out" ] || out="完成"
    RESULT="$out"
    RESULT_TITLE="$label"
done

printf '\033[H\033[J'
say "已退出 sing-box (runsv) 操作菜单"
