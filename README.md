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
age and revision version (the ABI-version or VERSION).

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

Note that the VERSION must be (current - age).age.revision for qmake

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
    -I$PWD/_test/include/qmake-example-4.3
    $ pkg-config qmake-example-4.3 --libs
    -L$PWD/_test/lib -lqmake-example-4.3

And it means that you can do things like this now (and people who know about pkg-config will now be happy to know that they can use your library in their own favorite build environment).

    $ export LD_LIBRARY_PATH=$PWD/_test/lib
    $ echo -en "#include <qmake-example.h>\nmain() {} " > test.cpp
    $ g++ -fPIC test.cpp -o test.o `pkg-config qmake-example-4.3 --libs --cflags`
    $ ldd test.o 
        linux-gate.so.1 (0xb77b0000)
        libqmake-example-4.3.so.2 => $PWD/_test/lib/libqmake-example-4.3.so.2 (0xb77a6000)
        libstdc++.so.6 => /usr/lib/i386-linux-gnu/libstdc++.so.6 (0xb75f5000)
        libm.so.6 => /lib/i386-linux-gnu/libm.so.6 (0xb759e000)
        libgcc_s.so.1 => /lib/i386-linux-gnu/libgcc_s.so.1 (0xb7580000)
        libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0xb73c9000)
        /lib/ld-linux.so.2 (0xb77b2000)

### cmake in the cmake-example

Note that the VERSION must be (current - age).age.revision for cmake

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
    -- Installing: $PWD/_test/lib/libcmake-example-4.3.so.2.1.0
    -- Up-to-date: $PWD/_test/lib/libcmake-example-4.3.so.2
    -- Up-to-date: $PWD/_test/lib/libcmake-example-4.3.so
    -- Up-to-date: $PWD/_test/include/cmake-example-4.3/cmake-example.h
    -- Up-to-date: $PWD/_test/lib/pkgconfig/cmake-example-4.3.pc

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
    -I$PWD/_test/include/cmake-example-4.3
    $ pkg-config cmake-example-4.3 --libs
    -L$PWD/_test/lib -lcmake-example-4.3

And it means that you can do things like this now (and people who know about pkg-config will now be happy to know that they can use your library in their own favorite build environment):

    $ echo -en "#include <cmake-example.h>\nmain() {} " > test.cpp
    $ g++ -fPIC test.cpp -o test.o `pkg-config cmake-example-4.3 --libs --cflags`
    $ ldd test.o
        linux-gate.so.1 (0xb7729000)
        libcmake-example-4.3.so.2 => $PWD/_test/lib/libcmake-example-4.3.so.2 (0xb771f000)
        libstdc++.so.6 => /usr/lib/i386-linux-gnu/libstdc++.so.6 (0xb756e000)
        libm.so.6 => /lib/i386-linux-gnu/libm.so.6 (0xb7517000)
        libgcc_s.so.1 => /lib/i386-linux-gnu/libgcc_s.so.1 (0xb74f9000)
        libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0xb7342000)
        /lib/ld-linux.so.2 (0xb772b000)

### autotools in the autotools-example

Note that you pass current:revision:age directly with autotools

To try this example out, go to the autotools-example directory and do

    $ cd autotools-example
    $ mkdir _test
    $ libtoolize
    $ aclocal
    $ autoheader
    $ autoconf
    $ automake --add-missing
    $ ./configure --prefix=$PWD/_test
    $ make
    $ make install

This should give you this:

    $ tree _test/
    _test/
    ├── include
    │   └── autotools-example-4.3
    │       └── autotools-example.h
    └── lib
        ├── libautotools-example-4.3.a
        ├── libautotools-example-4.3.la
        ├── libautotools-example-4.3.so -> libautotools-example-4.3.so.2.1.0
        ├── libautotools-example-4.3.so.2 -> libautotools-example-4.3.so.2.1.0
        ├── libautotools-example-4.3.so.2.1.0
        └── pkgconfig
            └── autotools-example-4.3.pc

When you now use pkg-config, you get a nice CFLAGS and LIBS line back (I'm replacing the current path with $PWD in the output each time):

    $  export PKG_CONFIG_PATH=$PWD/_test/lib/pkgconfig
    $ pkg-config autotools-example-4.3 --cflags
    -I$PWD/_test/include/autotools-example-4.3
    $ pkg-config autotools-example-4.3 --libs
    -L$PWD/_test/lib -lautotools-example-4.3

And it means that you can do things like this now (and people who know about pkg-config will now be happy to know that they can use your library in their own favorite build environment):

    $ echo -en "#include <autotools-example.h>\nmain() {} " > test.cpp
    $ export LD_LIBRARY_PATH=$PWD/_test/lib
    $ g++ -fPIC test.cpp -o test.o `pkg-config autotools-example-4.3 --libs --cflags`
    $ ldd test.o 
        linux-gate.so.1 (0xb778d000)
        libautotools-example-4.3.so.2 => $PWD/_test/lib/libautotools-example-4.3.so.2 (0xb7783000)
        libstdc++.so.6 => /usr/lib/i386-linux-gnu/libstdc++.so.6 (0xb75d2000)
        libm.so.6 => /lib/i386-linux-gnu/libm.so.6 (0xb757b000)
        libgcc_s.so.1 => /lib/i386-linux-gnu/libgcc_s.so.1 (0xb755d000)
        libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0xb73a6000)
        /lib/ld-linux.so.2 (0xb778f000)

