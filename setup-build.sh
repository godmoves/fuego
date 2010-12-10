#!/bin/sh
# Set up some commonly used build configurations for Fuego.
# This is a convenience script for developers that assumes a recent version
# of GCC and sets up build configurations for optimized and debug builds in
# the subdirectory "build".

DEFAULT_TARGETS="dbg opt opt-9"
if test $# -eq 0 ; then
    TARGETS="$DEFAULT_TARGETS"
else
    TARGETS="$@"
fi

# Optimization options for the GCC compiler.
GCC_OPTIMIZE="-O3 -ffast-math"
if ! gcc -v 2>&1 | grep -q 'gcc version 4.2' ; then
    # Value "native" for -march requires at least GCC 4.3
    GCC_OPTIMIZE="$GCC_OPTIMIZE -march=native"
fi

aclocal
autoheader
autoreconf -i

setup() {
    TARGET="$1"
    case "$TARGET" in
	dbg)
	    CXXFLAGS="-g -pipe"
	    CONFIGUREFLAGS="--enable-assert=yes"
	    ;;
	dbg-9)
	    CXXFLAGS="-g -pipe"
	    CONFIGUREFLAGS="--enable-assert=yes --enable-max-size=9"
	    ;;
	opt)
	    CXXFLAGS="$GCC_OPTIMIZE -g -pipe"
	    CONFIGUREFLAGS=""
	    ;;
	opt-9)
	    CXXFLAGS="$GCC_OPTIMIZE -g -pipe"
	    CONFIGUREFLAGS="--enable-max-size=9"
	    ;;
	*)
	    echo "Unknown target '$TARGET'"; exit 1
	    ;;
    esac
    echo ======================================================================
    echo Setting up target $TARGET
    echo ======================================================================
    mkdir -p "build/$TARGET"
    (
	cd "build/$TARGET"
	env CXXFLAGS="$CXXFLAGS" ../../configure \
          --enable-maintainer-mode $CONFIGUREFLAGS
	make clean
    )
}

for T in $TARGETS; do setup "$T"; done
