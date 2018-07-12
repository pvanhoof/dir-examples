# Doing It Right examples

The DIR examples are examples for various build environments on how
to create a good project structure that will build libraries that
are properly versioned with libtool, have a pkg-config file and that
have a so called API version in the library's name.

Information on this can be found in the Autotools Mythbuster docs:
https://autotools.io/libtool/version.html

## Supported build environments

1. qmake in the qmake-example

To try this example out, go to the qmake-example directory and type

    cd qmake-example
    mkdir=_test
    qmake PREFIX=$PWD/_test
    make
    make install
    echo Results:
    tree _test
    find _test

This should give you this:

    _test/
    ├── include
    │   └── qmake-example-3.2
    │       └── qmake-example.h
    └── lib
        ├── libqmake-example-3.2.so -> libqmake-example-3.2.so.3.2.1
        ├── libqmake-example-3.2.so.3 -> libqmake-example-3.2.so.3.2.1
        ├── libqmake-example-3.2.so.3.2 -> libqmake-example-3.2.so.3.2.1
        ├── libqmake-example-3.2.so.3.2.1
        ├── libqmake-example-3.la
        └── pkgconfig
            └── qmake-example-3.pc

When you now use pkg-config, you get a nice CFLAGS and LIBS line back (I'm replacing the current path with $PWD in the output each time):

    $ export PKG_CONFIG_PATH=$PWD/_test/lib/pkgconfig
    $ pkg-config qmake-example-3 --cflags
    -I$PWD/_test//include/qmake-example-3.2 -I/usr/include/i386-linux-gnu/qt5/QtCore -I/usr/include/i386-linux-gnu/qt5
    $ pkg-config qmake-example-3 --libs
    -L$PWD/_test//lib -lqmake-example-3.2 -lQt5Core
    $

And it means that you can do things like this now (and people who know
about pkg-config will now be happy to know that they can use your library
in their own favorite build environment):

    $ export LD_LIBRARY_PATH=$PWD/_test/lib
    $ echo -en "#include <qmake-example.h>\nmain() {} " > test.cpp
    $ g++ -fPIC test.cpp -o test.o `pkg-config qmake-example-3 --libs --cflags`
    $ ldd test.o 
    	linux-gate.so.1 (0xb7708000)
    	libqmake-example-3.2.so.3 => $PWD/_test/lib/libqmake-example-3.2.so.3 (0xb76fd000)
    	libQt5Core.so.5 => /usr/lib/i386-linux-gnu/sse2/libQt5Core.so.5 (0xb71e2000)
    	libstdc++.so.6 => /usr/lib/i386-linux-gnu/libstdc++.so.6 (0xb7066000)
    	libm.so.6 => /lib/i386-linux-gnu/libm.so.6 (0xb7011000)
    	libgcc_s.so.1 => /lib/i386-linux-gnu/libgcc_s.so.1 (0xb6ff3000)
    	libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0xb6e3c000)
    	libpthread.so.0 => /lib/i386-linux-gnu/libpthread.so.0 (0xb6e1f000)
    	libz.so.1 => /lib/i386-linux-gnu/libz.so.1 (0xb6e04000)
    	libicui18n.so.57 => /usr/lib/i386-linux-gnu/libicui18n.so.57 (0xb6b67000)
    	libicuuc.so.57 => /usr/lib/i386-linux-gnu/libicuuc.so.57 (0xb69b9000)
    	libpcre16.so.3 => /usr/lib/i386-linux-gnu/libpcre16.so.3 (0xb694c000)
    	libdouble-conversion.so.1 => /usr/lib/i386-linux-gnu/libdouble-conversion.so.1 (0xb6937000)
    	libdl.so.2 => /lib/i386-linux-gnu/libdl.so.2 (0xb6932000)
    	libglib-2.0.so.0 => /lib/i386-linux-gnu/libglib-2.0.so.0 (0xb6804000)
    	librt.so.1 => /lib/i386-linux-gnu/librt.so.1 (0xb67fb000)
    	/lib/ld-linux.so.2 (0xb770a000)
    	libicudata.so.57 => /usr/lib/i386-linux-gnu/libicudata.so.57 (0xb4f7d000)
    	libpcre.so.3 => /lib/i386-linux-gnu/libpcre.so.3 (0xb4f04000)

