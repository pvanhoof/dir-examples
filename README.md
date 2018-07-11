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

