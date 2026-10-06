#!/bin/bash
#
# Decide which module channel(s) need a new release: a channel is selected when
# the latest upstream sing-box tag for it has no GitHub release in this repo
# yet, or when that release is still missing the nomount/mount asset pairs
# (e.g. a release published before the variant split). Prints the selected
# channel names (space separated) and writes them to $GITHUB_OUTPUT as
# "channels=<...>".
#
# Environment:
#   CHANNEL_INPUT  auto | stable | prerelease   (default: auto)
#   FORCE          true to select even if the release already exists
#   REPO_SLUG      this repo                    (default: sorubedo/sing-box-magisk-runsv)
#   SB_REPO        upstream repo                (default: SagerNet/sing-box)
#   GH_TOKEN       token for the GitHub API     (optional; raises rate limit)
#

set -euo pipefail

REPO_SLUG="${REPO_SLUG:-sorubedo/sing-box-magisk-runsv}"
SB_REPO="${SB_REPO:-SagerNet/sing-box}"
CHANNEL_INPUT="${CHANNEL_INPUT:-auto}"
FORCE="${FORCE:-false}"

api() {
    url="$1"
    # --retry-all-errors + --http1.1: the releases list is a large document and
    # HTTP/2 streams occasionally get cancelled mid-transfer on CI runners.
    set -- -fsSL --http1.1 --retry 3 --retry-delay 2 --retry-all-errors \
        -H "Accept: application/vnd.github+json"
    if [ -n "${GH_TOKEN:-}" ]; then
        curl "$@" -H "Authorization: Bearer $GH_TOKEN" "$url"
    else
        curl "$@" "$url"
    fi
}

latest_stable_tag() {
    api "https://api.github.com/repos/$SB_REPO/releases/latest" | jq -r '.tag_name // empty'
}

latest_prerelease_tag() {
    api "https://api.github.com/repos/$SB_REPO/releases?per_page=30" \
        | jq -r '[.[] | select(.prerelease == true)][0].tag_name // empty'
}

# True when the release exists at all (used only to phrase the log message).
release_exists() {
    api "https://api.github.com/repos/$REPO_SLUG/releases/tags/$1" >/dev/null 2>&1
}

# True only when the release exists AND carries both the nomount and mount
# ZIPs. A release missing either variant is treated as "needs republishing".
release_has_variant_assets() {
    api "https://api.github.com/repos/$REPO_SLUG/releases/tags/$1" 2>/dev/null \
        | jq -e '([.assets[].name | select(test("-nomount-.+\\.zip$"))] | length > 0)
                 and ([.assets[].name | select(test("-mount-.+\\.zip$"))] | length > 0)' \
        >/dev/null 2>&1
}

case "$CHANNEL_INPUT" in
    auto) CHANNELS="stable prerelease" ;;
    stable | prerelease) CHANNELS="$CHANNEL_INPUT" ;;
    *)
        echo "ERROR: unknown channel '$CHANNEL_INPUT' (auto|stable|prerelease)" >&2
        exit 1
        ;;
esac

SELECTED=""
for ch in $CHANNELS; do
    case "$ch" in
        stable) tag="$(latest_stable_tag)" ;;
        prerelease) tag="$(latest_prerelease_tag)" ;;
    esac

    if [ -z "$tag" ]; then
        echo "skip $ch: no upstream tag found" >&2
        continue
    fi

    if [ "$FORCE" != "true" ]; then
        if release_has_variant_assets "$tag"; then
            echo "skip $ch: $tag already released with nomount/mount assets" >&2
            continue
        fi
        if release_exists "$tag"; then
            echo "republish $ch: $tag is missing nomount/mount assets" >&2
        fi
    fi

    echo "select $ch: $tag" >&2
    SELECTED="${SELECTED:+$SELECTED }$ch"
done

echo "$SELECTED"
if [ -n "${GITHUB_OUTPUT:-}" ]; then
    echo "channels=$SELECTED" >> "$GITHUB_OUTPUT"
fi
