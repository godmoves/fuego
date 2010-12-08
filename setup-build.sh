#!/bin/sh
# This script sets up some commonly used build targets for Fuego.

DEFAULT_TARGETS="dbg opt opt-9"

if test $# -eq 0 ; then
    TARGETS="$DEFAULT_TARGETS"
else
    TARGETS="$@"
fi

aclocal
autoheader
autoreconf -i

setup() {
    TARGET="$1"
    # Optimization options for the GCC compiler.
    GCC_OPTIMIZE="-O3 -march=native"
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