#!/bin/bash
#
# Build and publish one release channel (stable | prerelease):
#   fetch sing-box binaries -> package every ABI -> create/update the GitHub
#   release -> regenerate update/<channel>/<abi>.json.
#
# Meant to run inside the "Build and Release" workflow, but a local dry run is
# possible with DRY_RUN=true (skips the GitHub release calls).
#
# Environment:
#   REPO_SLUG  this repo (default: sorubedo/sing-box-magisk-runsv)
#   GH_TOKEN   token used by `gh release ...` (required unless DRY_RUN=true)
#   DRY_RUN    true to skip creating/updating the GitHub release
#

set -euo pipefail

CHANNEL="${1:?usage: release-channel.sh <stable|prerelease>}"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT_DIR="$PROJECT_DIR/out"
REPO_SLUG="${REPO_SLUG:-sorubedo/sing-box-magisk-runsv}"
DRY_RUN="${DRY_RUN:-false}"

case "$CHANNEL" in
    stable | prerelease) ;;
    *)
        echo "ERROR: unknown channel '$CHANNEL'" >&2
        exit 1
        ;;
esac

cd "$PROJECT_DIR"

echo "==> [$CHANNEL] fetch sing-box binaries"
bash fetch.sh "$CHANNEL"

set -a
# shellcheck disable=SC1091
. "$OUT_DIR/upstream-versions.env"
set +a

TAG="$SING_BOX_TAG"
VERSION="$SING_BOX_VERSION"
NOTES="$OUT_DIR/release-notes.md"

echo "==> [$CHANNEL] package $VERSION"
bash package.sh

# --- release notes ----------------------------------------------------
{
    echo "## Build information"
    echo
    echo "| Component | Value |"
    echo "| --- | --- |"
    echo "| Module | sing-box-runsv |"
    echo "| Channel | $MODULE_CHANNEL |"
    echo "| Module version | $VERSION |"
    echo "| sing-box upstream | [$TAG](https://github.com/SagerNet/sing-box/releases/tag/$TAG) |"
    echo
    echo "The module version and versionCode are derived from the upstream sing-box release."
    echo
    echo "## ABI packages"
    echo
    echo "| Asset suffix | Android / Magisk architecture |"
    echo "| --- | --- |"
    echo "| arm64-v8a | arm64 |"
    echo "| armeabi-v7a | arm |"
    echo "| x86_64 | x64 |"
    echo "| x86 | x86 |"
    echo
    echo "Each ZIP contains the binary for one ABI only. Download the asset matching the target device."
    echo
    echo "Requires [runsvdir-magisk](https://github.com/sorubedo/runsvdir-magisk) to be installed and rebooted first."
    echo
    echo "## SHA-256"
    echo
    echo '```text'
    cat "$OUT_DIR/SHA256SUMS"
    echo '```'
} > "$NOTES"

[ -n "${GITHUB_STEP_SUMMARY:-}" ] && cat "$NOTES" >> "$GITHUB_STEP_SUMMARY"

# --- GitHub release ---------------------------------------------------
PRERELEASE_FLAG=""
[ "$CHANNEL" = "prerelease" ] && PRERELEASE_FLAG="--prerelease"

if [ "$DRY_RUN" = "true" ]; then
    echo "==> [$CHANNEL] DRY_RUN: would release $TAG"
else
    if gh release view "$TAG" >/dev/null 2>&1; then
        echo "==> [$CHANNEL] update existing release $TAG"
        gh release upload "$TAG" \
            "$OUT_DIR"/*.zip "$OUT_DIR/SHA256SUMS" "$OUT_DIR/upstream-versions.env" \
            --clobber
        # shellcheck disable=SC2086
        gh release edit "$TAG" --title "$TAG (runsv module)" --notes-file "$NOTES" $PRERELEASE_FLAG
    else
        echo "==> [$CHANNEL] create release $TAG"
        # shellcheck disable=SC2086
        gh release create "$TAG" \
            --title "$TAG (runsv module)" \
            --notes-file "$NOTES" \
            $PRERELEASE_FLAG \
            "$OUT_DIR"/*.zip "$OUT_DIR/SHA256SUMS" "$OUT_DIR/upstream-versions.env"
    fi
fi

echo "==> [$CHANNEL] publish update metadata"
bash publish-update.sh

echo "==> [$CHANNEL] done: $TAG"
