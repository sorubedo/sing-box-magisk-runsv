#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
NAME="sing-box-runsv"
OUT_DIR="$PROJECT_DIR/out"
SUPPORTED_ABIS=(arm64-v8a armeabi-v7a x86_64 x86)
BINARY=sing-box
COMMON_FILES=(META-INF customize.sh uninstall.sh action.sh module.prop service)

usage() {
    echo "Usage: $0 [arm64-v8a|armeabi-v7a|x86_64|x86 ...]"
    echo "With no ABI arguments, packages all supported ABIs separately."
}

is_supported_abi() {
    local candidate="$1"
    local supported
    for supported in "${SUPPORTED_ABIS[@]}"; do
        [ "$candidate" = "$supported" ] && return 0
    done
    return 1
}

# Effective module version: prefer the fetched upstream version, fall back to
# the values committed in module.prop for local/dev builds.
if [ -f "$OUT_DIR/upstream-versions.env" ]; then
    # shellcheck disable=SC1091
    source "$OUT_DIR/upstream-versions.env"
    VERSION="${SING_BOX_VERSION:?missing SING_BOX_VERSION in upstream-versions.env}"
    VERSION_CODE="${SING_BOX_VERSION_CODE:?missing SING_BOX_VERSION_CODE}"
    CHANNEL="${MODULE_CHANNEL:-unknown}"
else
    VERSION="$(sed -n 's/^version=//p' "$PROJECT_DIR/module.prop")"
    VERSION_CODE="$(sed -n 's/^versionCode=//p' "$PROJECT_DIR/module.prop")"
    CHANNEL="local"
fi

# Replace version/versionCode in a staged module.prop, keeping line order.
stamp_module_prop() {
    local file="$1" tmp="$1.tmp"
    while IFS= read -r line; do
        case "$line" in
            version=*) echo "version=$VERSION" ;;
            versionCode=*) echo "versionCode=$VERSION_CODE" ;;
            *) echo "$line" ;;
        esac
    done < "$file" > "$tmp"
    mv "$tmp" "$file"
}

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
    usage
    exit 0
fi

if [ "$#" -gt 0 ]; then
    ABIS=("$@")
else
    ABIS=("${SUPPORTED_ABIS[@]}")
fi

for ABI in "${ABIS[@]}"; do
    if ! is_supported_abi "$ABI"; then
        echo "ERROR: unsupported ABI: $ABI" >&2
        usage >&2
        exit 1
    fi
done

mkdir -p "$OUT_DIR"
PACKAGES=()

echo "=> Module version: $VERSION (versionCode $VERSION_CODE, $CHANNEL)"

for ABI in "${ABIS[@]}"; do
    if [ ! -f "$PROJECT_DIR/bin/$ABI/$BINARY" ]; then
        echo "ERROR: missing bin/$ABI/$BINARY; run fetch.sh first" >&2
        exit 1
    fi

    STAGE_DIR="$(mktemp -d)"
    trap 'rm -rf "$STAGE_DIR"' EXIT

    for path in "${COMMON_FILES[@]}"; do
        cp -a "$PROJECT_DIR/$path" "$STAGE_DIR/"
    done
    chmod 755 "$STAGE_DIR/META-INF/com/google/android/update-binary"
    chmod 755 "$STAGE_DIR/customize.sh" "$STAGE_DIR/uninstall.sh" "$STAGE_DIR/action.sh"
    chmod 755 "$STAGE_DIR/service/sing-box/run" \
        "$STAGE_DIR/service/sing-box/finish" \
        "$STAGE_DIR/service/sing-box/log/run"

    mkdir -p "$STAGE_DIR/bin/$ABI"
    cp -a "$PROJECT_DIR/bin/$ABI/$BINARY" "$STAGE_DIR/bin/$ABI/"

    stamp_module_prop "$STAGE_DIR/module.prop"

    {
        echo "moduleVersion=$VERSION"
        echo "moduleVersionCode=$VERSION_CODE"
        echo "moduleChannel=$CHANNEL"
        echo "targetAbi=$ABI"
        [ ! -f "$OUT_DIR/upstream-versions.env" ] || cat "$OUT_DIR/upstream-versions.env"
    } > "$STAGE_DIR/build-info.prop"

    ZIP_NAME="${NAME}-${VERSION}-${ABI}.zip"
    ZIP_PATH="$OUT_DIR/$ZIP_NAME"
    rm -f "$ZIP_PATH"
    (cd "$STAGE_DIR" && zip -qr "$ZIP_PATH" .)
    PACKAGES+=("$ZIP_NAME")

    rm -rf "$STAGE_DIR"
    trap - EXIT
    echo "=> out/$ZIP_NAME ($(du -h "$ZIP_PATH" | cut -f1))"
done

(cd "$OUT_DIR" && sha256sum "${PACKAGES[@]}" > SHA256SUMS)
echo "=> out/SHA256SUMS"
