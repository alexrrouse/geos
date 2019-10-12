#!/bin/sh

set -e

if git rev-parse 2> /dev/null; [ $? == 0 ]; then
	git submodule update --init --recursive
fi

cd geos

type -P autoconf &>/dev/null || alias autoconf 'xcrun autoconf'
type -P autoheader &>/dev/null || alias autoheader 'xcrun autoheader'
type -P aclocal &>/dev/null || alias aclocal 'xcrun aclocal'
type -P automake &>/dev/null || alias automake 'xcrun automake'
type -P glibtool &>/dev/null || alias glibtool 'xcrun glibtool'
type -P glibtoolize &>/dev/null || alias glibtoolize 'xcrun glibtoolize'

sh autogen.sh
./configure

echo "\
#pragma clang diagnostic push\n\
#pragma clang diagnostic ignored \"-Wstrict-prototypes\"\n\
$(cat capi/geos_c.h)\n\
#pragma clang diagnostic pop" > capi/geos_c.h
