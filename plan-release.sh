#!/bin/bash
#
# Decide which module channel(s) need a new release: a channel is selected when
# the latest upstream sing-box tag for it has no GitHub release in this repo
# yet. Prints the selected channel names (space separated) and writes them to
# $GITHUB_OUTPUT as "channels=<...>".
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
    if [ -n "${GH_TOKEN:-}" ]; then
        curl -fsSL -H "Authorization: Bearer $GH_TOKEN" \
            -H "Accept: application/vnd.github+json" "$1"
    else
        curl -fsSL -H "Accept: application/vnd.github+json" "$1"
    fi
}

latest_stable_tag() {
    api "https://api.github.com/repos/$SB_REPO/releases/latest" | jq -r '.tag_name // empty'
}

latest_prerelease_tag() {
    api "https://api.github.com/repos/$SB_REPO/releases?per_page=30" \
        | jq -r '[.[] | select(.prerelease == true)][0].tag_name // empty'
}

release_exists() {
    api "https://api.github.com/repos/$REPO_SLUG/releases/tags/$1" >/dev/null 2>&1
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

    if [ "$FORCE" != "true" ] && release_exists "$tag"; then
        echo "skip $ch: $tag already released" >&2
        continue
    fi

    echo "select $ch: $tag" >&2
    SELECTED="${SELECTED:+$SELECTED }$ch"
done

echo "$SELECTED"
if [ -n "${GITHUB_OUTPUT:-}" ]; then
    echo "channels=$SELECTED" >> "$GITHUB_OUTPUT"
fi
