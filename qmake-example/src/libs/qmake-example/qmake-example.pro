## We get the PREFIX, MAJOR_VERSION, MINOR_VERSION and PATCH_VERSION
## from this project-wide include

include(../../../qmake-example.pri)

## We will use the standard lib template of qmake

TEMPLATE = lib

## We need to set VERSION to a semver.org version for compile_libtool

VERSION = $${MAJOR_VERSION}"."$${MINOR_VERSION}"."$${PATCH_VERSION}

## According https://autotools.io/libtool/version.html, section 4.3
## we should have as target-name the API version in the library's name

TARGET = qmake-example-$${MAJOR_VERSION}"."$${MINOR_VERSION}

## We will write a define in config.h for access to the semver.org
## version as a double quoted string

QMAKE_SUBSTITUTES += config.h.in

## Our example happens to use QDebug, so we need QtCore here

QT = core

## This is of course optional

CONFIG += c++14

## We will be using libtool style libraries

CONFIG += compile_libtool
CONFIG += create_libtool

## These will create a pkg-config .pc file for us

CONFIG += create_pc create_prl no_install_prl

## Project sources

SOURCES = \
	qmake-example.cpp

## Project headers

HEADERS = \
	qmake-example.h

## We will install the headers in a API specific include path

headers.path = $${PREFIX}/include/qmake-example-$${MAJOR_VERSION}"."$${MINOR_VERSION}

## Here will go all the installed headers

headers.files = $${HEADERS}

## Here we will install the library to
target.path = $${PREFIX}/lib

## This is the configuration for generating the pkg-config file

QMAKE_PKGCONFIG_NAME = $${TARGET}
QMAKE_PKGCONFIG_DESCRIPTION = An example that illustrates how to do it right with qmake

# This is our libdir
QMAKE_PKGCONFIG_LIBDIR = $$target.path

# This is where our API specific headers are
QMAKE_PKGCONFIG_INCDIR = $$headers.path
QMAKE_PKGCONFIG_DESTDIR = pkgconfig
QMAKE_PKGCONFIG_PREFIX = $${PREFIX}
QMAKE_PKGCONFIG_VERSION = $$VERSION

## Installation targets (the pkg-config seems to install automatically)

INSTALLS += headers target
