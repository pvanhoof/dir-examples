# Doing It Right examples

The DIR examples are examples for various build environments on how
to create a good project structure that will build libraries that
are properly versioned with libtool, have a pkg-config file and that
have a so called API version in the library's name.

Information on this can be found in the Autotools Mythbuster docs:
https://autotools.io/libtool/version.html

## What is right?

In the examples I try to follow as much as possible the Autotools
Mythbuster docs (https://autotools.io/libtool/version.html)

You'll notice that a library called package will in /usr/lib often be
called something like libpackage-4.3.so.2.1.0

We call the 4.3 part the API version (the APIVERSION), and the 2.1.0 the current,
revision and age version (the ABI-version or VERSION).

The document libtool/version.html on autotools.io states:

The rules of thumb, when dealing with these values are:

* Increase the current value whenever an interface has been added, removed or changed.
* Always increase the revision value.
* Increase the age value only if the changes made to the ABI are backward compatible.

For the API version I will use the rules from http://semver.org:

Given a version number MAJOR.MINOR.PATCH, increment the:

1. MAJOR version when you make incompatible API changes,
2. MINOR version when you add functionality in a backwards-compatible manner, and
3. PATCH version when you make backwards-compatible bug fixes.

Many people use many build environments (autotools, qmake, cmake, meson, you name it).
Nowadays almost all of those build environments support pkg-config out of the box. I
consider it a necessity to ship with a useful and correct pkg-config .pc file.

When you have an API then that API can change over time. You typically want
to version those API changes so that the users of your library can adopt to
newer versions of the API while at the same time still using older versions of
the API. For this we need to follow 4.3. Multiple libraries versions of the
Autotools Mythbuster documentation (https://autotools.io/libtool/version.html)
which states:

In this situation, the best option is to append part of the library's version information to the library's name, which is exemplified by Glib's libglib-2.0.so.0 soname. To do so, the declaration in the Makefile.am has to be like this:

    lib_LTLIBRARIES = libtest-1.0.la
    
    libtest_1_0_la_LDFLAGS = -version-info 0:0:0

I consider it a necessity to ship API headers in a per API-version different
location (like /usr/include/glib-2.0). This means that your API version number
must be part of the include-path. This implies that the pkg-config .pc file
must also be versioned (like /usr/lib/pkgconfig/glib-2.0.pc)

For example using earlier mentioned API-version 4.3, /usr/include/package-4.3 for
/usr/lib/libpackage-4.3.so(.2.1.0) having /usr/lib/pkg-config/package-4.3.pc

## Supported build environments

### qmake in the qmake-example

To try this example out, go to the qmake-example directory and type

    $ cd qmake-example
    $ mkdir=_test
    $ qmake PREFIX=$PWD/_test
    $ make
    $ make install
 
This should give you this:

    $ find _test/
    _test/
    ├── include
    │   └── qmake-example-4.3
    │       └── qmake-example.h
    └── lib
        ├── libqmake-example-4.3.so -> libqmake-example-4.3.so.2.1.0
        ├── libqmake-example-4.3.so.2 -> libqmake-example-4.3.so.2.1.0
        ├── libqmake-example-4.3.so.2.1 -> libqmake-example-4.3.so.2.1.0
        ├── libqmake-example-4.3.so.2.1.0
        ├── libqmake-example-4.la
        └── pkgconfig
            └── qmake-example-4.3.pc

When you now use pkg-config, you get a nice CFLAGS and LIBS line back (I'm replacing the current path with $PWD in the output each time):

    $ export PKG_CONFIG_PATH=$PWD/_test/lib/pkgconfig
    $ pkg-config qmake-example-4.3 --cflags
    -I$PWD/_test//include/qmake-example-4.3 -I/usr/include/i386-linux-gnu/qt5/QtCore
    -I/usr/include/i386-linux-gnu/qt5
    $ pkg-config qmake-example-4.3 --libs
    -L$PWD/_test//lib -lqmake-example-4.3 -lQt5Core

And it means that you can do things like this now (and people who know about pkg-config will now be happy to know that they can use your library in their own favorite build environment). The extra linking is mostly due to Qt5Core of course (only for the purpose of the example):

    $ export LD_LIBRARY_PATH=$PWD/_test/lib
    $ echo -en "#include <qmake-example.h>\nmain() {} " > test.cpp
    $ g++ -fPIC test.cpp -o test.o `pkg-config qmake-example-4.3 --libs --cflags`
    $ ldd test.o 
        linux-gate.so.1 (0xb7708000)
        libqmake-example-4.3.so.2 => $PWD/_test/lib/libqmake-example-4.3.so.2 (0xb76fd000)
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

### cmake in the cmake-example

To try this example out, go to the cmake-example directory and do

    $ cd cmake-example
    $ mkdir _test
    $ cmake -DCMAKE_INSTALL_PREFIX:PATH=$PWD/_test
    -- Configuring done
    -- Generating done
    -- Build files have been written to: .
    $ make
    [ 50%] Building CXX object src/libs/cmake-example/CMakeFiles/cmake-example.dir/cmake-example.cpp.o
    [100%] Linking CXX shared library libcmake-example-4.3.so
    [100%] Built target cmake-example
    $ make install
    [100%] Built target cmake-example
    Install the project...
    -- Install configuration: ""
    -- Installing: $PWD/lib/libcmake-example-4.3.so.2.1.0
    -- Up-to-date: $PWD/lib/libcmake-example-4.3.so.2
    -- Up-to-date: $PWD/lib/libcmake-example-4.3.so
    -- Up-to-date: $PWD/include/cmake-example-4.3/cmake-example.h
    -- Up-to-date: $PWD/lib/pkgconfig/cmake-example-4.3.pc

This should give you this:

    $ tree _test/
    _test/
    ├── include
    │   └── cmake-example-4.3
    │       └── cmake-example.h
    └── lib
        ├── libcmake-example-4.3.so -> libcmake-example-4.3.so.2
        ├── libcmake-example-4.3.so.2 -> libcmake-example-4.3.so.2.1.0
        ├── libcmake-example-4.3.so.2.1.0
        └── pkgconfig
            └── cmake-example-4.3.pc

When you now use pkg-config, you get a nice CFLAGS and LIBS line back (I'm replacing the current path with $PWD in the output each time):

    $ pkg-config cmake-example-4.3 --cflags
    -I$PWD/include/cmake-example-4.3
    $ pkg-config cmake-example-4.3 --libs
    -L$PWD/lib -lcmake-example-4.3

And it means that you can do things like this now (and people who know about pkg-config will now be happy to know that they can use your library in their own favorite build environment):

    $ echo -en "#include <cmake-example.h>\nmain() {} " > test.cpp
    $ g++ -fPIC test.cpp -o test.o `pkg-config cmake-example-4.3 --libs --cflags`
    $ ldd test.o
        linux-gate.so.1 (0xb7729000)
        libcmake-example-4.3.so.2 => $PWD/lib/libcmake-example-4.3.so.2 (0xb771f000)
        libstdc++.so.6 => /usr/lib/i386-linux-gnu/libstdc++.so.6 (0xb756e000)
        libm.so.6 => /lib/i386-linux-gnu/libm.so.6 (0xb7517000)
        libgcc_s.so.1 => /lib/i386-linux-gnu/libgcc_s.so.1 (0xb74f9000)
        libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0xb7342000)
        /lib/ld-linux.so.2 (0xb772b000)

### autotools in the autotools-example

### meson in the meson-example

### qbx in the qbx-example

### Others as contributed by people who took the time to also do it right


