## We get the PREFIX, MAJOR_VERSION, MINOR_VERSION and PATCH_VERSION
## from this project-wide include. The version numbers are semver.

include(../../../qmake-example.pri)

## We will use the standard lib template of qmake

TEMPLATE = lib

## According to https://autotools.io/libtool/version.html, section 4.1
## Setting the proper Shared Object Version we need to :
##
##     o. Increase the current value whenever an interface has been
##        added, removed or changed.
##     o. Always increase the revision value.
##     o. Increase the age value only if the changes made to the ABI
##        are backward compatible.
##
## For simplicity I am for now going to use the three numbers major,
## minor and patch from semver for libtool's current, revision and age.
## To be fully correct would changes in both minor and major cause a
## increment in current, and must revision also always be incremented.
## But that is hard to show in an example like this.
##
## The point of current, revision and age are that they form your ABI
## version. The point of major, minor (and patch) of semver is that it
## forms your API version.

CURRENT_VERSION = $${MAJOR_VERSION}
REVISION_VERSION = $${MINOR_VERSION}
AGE_VERSION = $${PATCH_VERSION}

## The libtool support in qmake assumes the VERSION variable to contain
## current, revision and age. Most people use (or think that) a semver
## x.y.z numbering for VERSION is what to use (so don't get confused,
## this is for configuring the compile_libtool stuff). I'm using the
## same variable names as in cmake here.

VERSION = $${CURRENT_VERSION}"."$${REVISION_VERSION}"."$${AGE_VERSION}

## We will therefor also make ourselves a semver-version, to be put in
## the config.h as a VERSION #define. Again, don't get confused about this.

SEMVER_VERSION = $${MAJOR_VERSION}"."$${MINOR_VERSION}"."$${PATCH_VERSION}

## The SOVERSION is the API version. I use the same variable names as
## in the cmake world here. Usually we can take major and minor from semver
## for this.

SOVERSION = $${MAJOR_VERSION}"."$${MINOR_VERSION}

## According to https://autotools.io/libtool/version.html, section 4.3
## Multiple libraries versions, we should have as target-name the API
## version in the library's name. The so called SOVERSION variable is
## a perfect candidates for this.
##
## Noting that for example a project like GLib keeps the API version
## number on 2.0, while they change the minor. They say that GLib 2.4
## has a GLib 2.0 API, I guess (up to you when maintaining a library)

TARGET = qmake-example-$${SOVERSION}

## We will write a define in config.h for access to the semver.org
## version as a double quoted string

QMAKE_SUBSTITUTES += config.h.in

## Our example happens to use QDebug, so we need QtCore here

QT = core

## This is of course optional

CONFIG += c++14

## We will be using libtool style libraries

CONFIG += compile_libtool create_libtool

## These will create a pkg-config .pc file for us

CONFIG += create_pc create_prl no_install_prl

## Project sources

SOURCES = \
	qmake-example.cpp

## Project's private and public headers

HEADERS = \
	qmake-example.h

## We will install the headers in a API specific include path

headers.path = $${PREFIX}/include/qmake-example-$${SOVERSION}

## Here we put only the publicly installed headers

headers.files = $${HEADERS}

## Here we will install the library to. If somebody has a better or
## more standardized way, let me know (I don't like this much)

target.path = $${PREFIX}/lib

## This is the configuration for generating the pkg-config file

QMAKE_PKGCONFIG_NAME = $${TARGET}
QMAKE_PKGCONFIG_DESCRIPTION = An example on how to do it right with qmake

# This is our libdir
QMAKE_PKGCONFIG_LIBDIR = $$target.path

# This is where our API specific headers are
QMAKE_PKGCONFIG_INCDIR = $$headers.path
QMAKE_PKGCONFIG_DESTDIR = pkgconfig
QMAKE_PKGCONFIG_PREFIX = $${PREFIX}

# Usually people take the semver version here
QMAKE_PKGCONFIG_VERSION = $${SEMVER_VERSION}

# This is what our library depends on
QMAKE_PKGCONFIG_REQUIRES = Qt5Core

## Installation targets (the pkg-config seems to install automatically)

INSTALLS += headers target
