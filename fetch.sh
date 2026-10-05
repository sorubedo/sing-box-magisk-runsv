#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$SCRIPT_DIR/bin"
OUT_DIR="$SCRIPT_DIR/out"
SB_REPO="SagerNet/sing-box"
CHANNEL="${1:-auto}"
SB_TMP="$(mktemp -d)"
trap 'rm -rf "$SB_TMP"' EXIT

# sing-box platform names in releases
declare -A SB_PLAT=(
    ["arm64-v8a"]="android-arm64"
    ["armeabi-v7a"]="android-arm"
    ["x86_64"]="android-amd64"
    ["x86"]="android-386"
)

usage() {
    cat <<EOF
Usage: $0 [stable|prerelease|auto|TAG]

  stable       latest stable sing-box release
  prerelease   latest sing-box pre-release
  auto         latest pre-release, falling back to stable (default)
  TAG          pin an explicit tag, e.g. v1.14.2

Downloads the Android binaries into bin/<abi>/ and writes
out/upstream-versions.env with the module version mapping.
EOF
}

api() { curl -sLS "https://api.github.com/repos/$SB_REPO/$1"; }

latest_prerelease() {
    api "releases?per_page=30" | jq -r '[.[] | select(.prerelease == true)] | .[0].tag_name // empty'
}

latest_stable() {
    api "releases/latest" | jq -r '.tag_name // empty'
}

case "$CHANNEL" in
    -h | --help)
        usage
        exit 0
        ;;
    stable)
        SB_TAG="$(latest_stable)"
        ;;
    prerelease)
        SB_TAG="$(latest_prerelease)"
        ;;
    auto)
        SB_TAG="$(latest_prerelease)"
        [ -n "$SB_TAG" ] || SB_TAG="$(latest_stable)"
        ;;
    v*)
        SB_TAG="$CHANNEL"
        ;;
    [0-9]*)
        SB_TAG="v$CHANNEL"
        ;;
    *)
        echo "Unknown channel or tag: $CHANNEL" >&2
        usage >&2
        exit 1
        ;;
esac

[ -n "$SB_TAG" ] || {
    echo "ERROR: could not resolve a sing-box tag for channel '$CHANNEL'" >&2
    exit 1
}

echo "=> sing-box: $SB_TAG"

for ABI in "${!SB_PLAT[@]}"; do
    PLAT="${SB_PLAT[$ABI]}"
    ASSET="sing-box-${SB_TAG#v}-${PLAT}.tar.gz"
    URL="https://github.com/$SB_REPO/releases/download/${SB_TAG}/${ASSET}"

    echo "   Downloading $ASSET..."
    if ! curl -fsSL "$URL" -o "$SB_TMP/$ASSET"; then
        echo "   skip $ABI: $ASSET not available"
        continue
    fi

    mkdir -p "$BIN_DIR/$ABI" "$SB_TMP/$ABI"
    tar xzf "$SB_TMP/$ASSET" -C "$SB_TMP/$ABI"
    find "$SB_TMP/$ABI" -name sing-box -type f -exec cp {} "$BIN_DIR/$ABI/sing-box" \;
    chmod 755 "$BIN_DIR/$ABI/sing-box"
    echo "   ok: bin/$ABI/sing-box ($(du -h "$BIN_DIR/$ABI/sing-box" | cut -f1))"
done

# --- map the upstream tag to module version / versionCode -------------
#
# versionCode layout (stays well below Magisk's 32-bit Int limit):
#
#   major * 10000000 + minor * 100000 + patch * 1000 + stage * 100 + ordinal
#
# stage orders builds with the same major.minor.patch:
#
#   alpha(1) < beta(2) < rc(3) < stable(9)
#
# ordinal is the trailing number of a pre-release (alpha.10 -> 10). Encoding it
# keeps every pre-release distinct, so pre-release -> pre-release updates are
# detected; the stage digit lets the stable build supersede the pre-release it
# was cut from. Every value produced here is larger than anything the old
# scheme produced, so existing installs still see the next build as an update.
VERSION="${SB_TAG#v}"
CORE="${VERSION%%-*}"
PRE="${VERSION#"$CORE"}"     # "", "-alpha.10", ...
PRE="${PRE#-}"

MAJOR="${CORE%%.*}"
REST="${CORE#*.}"
if [ "$REST" = "$CORE" ]; then
    MINOR=0
    PATCH=0
else
    MINOR="${REST%%.*}"
    PATCH="${REST#*.}"
    [ "$PATCH" = "$REST" ] && PATCH=0
fi

# keep only digits, so a malformed tag cannot break arithmetic
MAJOR="${MAJOR//[!0-9]/}"; MAJOR="${MAJOR:-0}"
MINOR="${MINOR//[!0-9]/}"; MINOR="${MINOR:-0}"
PATCH="${PATCH//[!0-9]/}"; PATCH="${PATCH:-0}"

if [ -z "$PRE" ]; then
    MODULE_CHANNEL=stable
    STAGE=9
    ORDINAL=0
else
    MODULE_CHANNEL=prerelease
    case "$PRE" in
        alpha*) STAGE=1 ;;
        beta*)  STAGE=2 ;;
        rc*)    STAGE=3 ;;
        *)      STAGE=1 ;;
    esac
    ORDINAL="${PRE##*.}"
    case "$ORDINAL" in
        '' | *[!0-9]*) ORDINAL=0 ;;
    esac
fi

VERSION_CODE=$((10#$MAJOR * 10000000 + 10#$MINOR * 100000 + 10#$PATCH * 1000 + STAGE * 100 + 10#$ORDINAL))

mkdir -p "$OUT_DIR"
cat > "$OUT_DIR/upstream-versions.env" <<EOF
SING_BOX_TAG=$SB_TAG
SING_BOX_VERSION=$VERSION
SING_BOX_VERSION_CODE=$VERSION_CODE
MODULE_CHANNEL=$MODULE_CHANNEL
EOF

echo ""
echo "=> Module version: $VERSION (versionCode $VERSION_CODE, $MODULE_CHANNEL)"
echo "=> Wrote out/upstream-versions.env"

if [ -n "${GITHUB_OUTPUT:-}" ]; then
    {
        echo "sing_box_tag=$SB_TAG"
        echo "sing_box_version=$VERSION"
        echo "sing_box_version_code=$VERSION_CODE"
        echo "module_channel=$MODULE_CHANNEL"
    } >> "$GITHUB_OUTPUT"
fi
