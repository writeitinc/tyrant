#!/bin/sh

DEST=$1

install -Dm755 -t "$DEST/usr/lib/" "build/lib/libtyrant.a"
install -Dm644 -t "$DEST/usr/include/tyrant/" "build/include/tyrant/tyrant.h"
install -Dm644 -t "$DEST/usr/share/licenses/tyrant/" "LICENSE"
install -Dm644 -t "$DEST/usr/share/doc/tyrant/" "README.md"
