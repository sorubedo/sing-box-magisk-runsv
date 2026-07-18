#!/bin/bash
set -euo pipefail

NAME="sing-box-runsv"
VERSION="$(grep '^version=' module.prop | cut -d= -f2)"
OUTDIR="out"
ZIP="${OUTDIR}/${NAME}-${VERSION}.zip"

mkdir -p "$OUTDIR"
rm -f "$ZIP"

zip -r "$ZIP" \
  META-INF/ \
  customize.sh \
  uninstall.sh \
  action.sh \
  module.prop \
  bin/ \
  sv/

echo "=> ${ZIP}"
