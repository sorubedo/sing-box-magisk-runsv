#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
NAME="sing-box-runsv"
VERSION="$(sed -n 's/^version=//p' "$PROJECT_DIR/module.prop")"
OUT_DIR="$PROJECT_DIR/out"
SUPPORTED_ABIS=(arm64-v8a armeabi-v7a x86_64 x86)
BINARIES=(sing-box subsing)
COMMON_FILES=(META-INF customize.sh uninstall.sh action.sh module.prop sv)

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

for ABI in "${ABIS[@]}"; do
    for binary in "${BINARIES[@]}"; do
        if [ ! -f "$PROJECT_DIR/bin/$ABI/$binary" ]; then
            echo "ERROR: missing bin/$ABI/$binary; run fetch.sh first" >&2
            exit 1
        fi
    done

    STAGE_DIR="$(mktemp -d)"
    trap 'rm -rf "$STAGE_DIR"' EXIT

    for path in "${COMMON_FILES[@]}"; do
        cp -a "$PROJECT_DIR/$path" "$STAGE_DIR/"
    done
    chmod 755 "$STAGE_DIR/META-INF/com/google/android/update-binary"
    mkdir -p "$STAGE_DIR/bin/$ABI"
    for binary in "${BINARIES[@]}"; do
        cp -a "$PROJECT_DIR/bin/$ABI/$binary" "$STAGE_DIR/bin/$ABI/"
    done

    {
        echo "moduleVersion=$VERSION"
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
