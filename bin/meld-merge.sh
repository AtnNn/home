#!/bin/sh
BASE="$1"
LOCAL="$2"
REMOTE="$3"
MERGED="$4"
meld "$LOCAL" "$BASE" "$REMOTE" || exit $?
cp "$BASE" "$MERGED"
exit 0
