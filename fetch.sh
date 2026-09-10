#!/bin/bash
set -euo pipefail

BIN_DIR="$(cd "$(dirname "$0")" && pwd)/bin"
OUT_DIR="$(cd "$(dirname "$0")" && pwd)/out"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

# sing-box platform names in releases
declare -A SB_PLAT=(
    ["arm64-v8a"]="android-arm64"
    ["armeabi-v7a"]="android-arm"
    ["x86_64"]="android-amd64"
    ["x86"]="android-386"
)

echo "=> sing-box: fetching latest pre-release..."

SB_TAG=$(curl -sLS "https://api.github.com/repos/SagerNet/sing-box/releases?per_page=10" | \
    jq -r '[.[] | select(.prerelease == true)] | .[0].tag_name // empty')

if [ -z "$SB_TAG" ]; then
    echo "   No pre-release, falling back to latest stable"
    SB_TAG=$(curl -sLS "https://api.github.com/repos/SagerNet/sing-box/releases/latest" | jq -r '.tag_name')
fi
echo "   Tag: $SB_TAG"

for ABI in "${!SB_PLAT[@]}"; do
    PLAT="${SB_PLAT[$ABI]}"
    ASSET="sing-box-${SB_TAG#v}-${PLAT}.tar.gz"
    URL="https://github.com/SagerNet/sing-box/releases/download/${SB_TAG}/${ASSET}"

    echo "   Downloading $ASSET..."
    curl -fsSL "$URL" -o "$TMPDIR/$ASSET" || { echo "   skip $ABI: 404"; continue; }

    mkdir -p "$BIN_DIR/$ABI" "$TMPDIR/$ABI"
    tar xzf "$TMPDIR/$ASSET" -C "$TMPDIR/$ABI"
    find "$TMPDIR/$ABI" -name sing-box -type f -exec cp {} "$BIN_DIR/$ABI/sing-box" \;
    chmod 755 "$BIN_DIR/$ABI/sing-box"
    echo "   ok: bin/$ABI/sing-box ($(du -h "$BIN_DIR/$ABI/sing-box" | cut -f1))"
done

echo ""
echo "=> Done: sing-box $SB_TAG"

mkdir -p "$OUT_DIR"
printf 'sing_box_version=%s\n' "$SB_TAG" > "$OUT_DIR/upstream-versions.env"
if [ -n "${GITHUB_OUTPUT:-}" ]; then
    printf 'sing_box_version=%s\n' "$SB_TAG" >> "$GITHUB_OUTPUT"
fi
