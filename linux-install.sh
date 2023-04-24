#!/bin/sh

DEST=${1%/} # strip trailing slash

VERSION='0.1.0'
VERSION_MAJOR=${VERSION%%.*}

install -v -Dm755 "build/lib/libtyrant.so" "$DEST/usr/lib/libtyrant.so.$VERSION"
ln -v -sn "libtyrant.so.$VERSION" "$DEST/usr/lib/libtyrant.so.$VERSION_MAJOR"
ln -v -sn "libtyrant.so.$VERSION_MAJOR" "$DEST/usr/lib/libtyrant.so"

install -v -Dm644 -t "$DEST/usr/lib/" "build/lib/libtyrant.a"
install -v -Dm644 -t "$DEST/usr/include/tyrant/" "build/include/tyrant/tyrant.h"
install -v -Dm644 -t "$DEST/usr/share/licenses/tyrant/" "LICENSE"
install -v -Dm644 -t "$DEST/usr/share/doc/tyrant/" "README.md"
