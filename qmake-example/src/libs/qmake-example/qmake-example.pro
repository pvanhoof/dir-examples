## We get the PREFIX, QMAKE_EXAMPLE_MAJOR_VERSION, QMAKE_EXAMPLE_SOVERSION,
## QMAKE_EXAMPLE_MINOR_VERSION, QMAKE_EXAMPLE_PATCH_VERSION,
## QMAKE_EXAMPLE_CURRENT_VERSION, QMAKE_EXAMPLE_REVISION_VERSION,
## QMAKE_EXAMPLE_VERSION and QMAKE_EXAMPLE_AGE_VERSION from this project-wide
## qmake-example.pri include file.

include(../../../qmake-example.pri)

## In qmake we have to remove qt explicitly if we don't want to link against it

CONFIG -= qt

## We will use the standard lib template of qmake

TEMPLATE = lib

# In qmake you need to use this VERSION variable for libtool's -version-info

VERSION = $${QMAKE_EXAMPLE_VERSION}

## We will therefor also make ourselves a semver-version, to be put in
## the config.h as a VERSION #define.

SEMVER_VERSION = $${QMAKE_EXAMPLE_MAJOR_VERSION}"."$${QMAKE_EXAMPLE_MINOR_VERSION}"."$${QMAKE_EXAMPLE_PATCH_VERSION}

## According to https://autotools.io/libtool/version.html, section 4.3
## Multiple libraries versions, we should have as target-name the API
## version in the library's name. The so called APIVERSION variable is
## a perfect candidate to use for this purpose.
##
## Noting that for example a project like GLib keeps the API version
## number on 2.0, while they change the minor. They say that GLib 2.4
## has a GLib 2.0 API, I guess (up to you when maintaining a library)

TARGET = qmake-example-$${QMAKE_EXAMPLE_APIVERSION}

## We will write a define in config.h for access to the semantic version
## as a double quoted string

QMAKE_SUBSTITUTES += config.h.in

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

headers.path = $${PREFIX}/include/qmake-example-$${QMAKE_EXAMPLE_APIVERSION}

## Here we put only the publicly installed headers

headers.files = $${HEADERS}

## Here we will install the library to. If somebody has a better or
## more standardized way, let me know (I don't like this very much)

target.path = $${PREFIX}/lib

## This is the configuration for generating the pkg-config file

# This makes sure that the pkg-config file is qmake-example-4.3.pc
QMAKE_PKGCONFIG_FILE = $${TARGET}

# This fills in the Name property
QMAKE_PKGCONFIG_NAME = $${TARGET}

# This fills in the Description property
QMAKE_PKGCONFIG_DESCRIPTION = An example on how to do it right with qmake

# This is our libdir
QMAKE_PKGCONFIG_LIBDIR = $$target.path

# This is where our API specific headers are
QMAKE_PKGCONFIG_INCDIR = $$headers.path
QMAKE_PKGCONFIG_DESTDIR = pkgconfig
QMAKE_PKGCONFIG_PREFIX = $${PREFIX}

# Usually people take the semver version here
QMAKE_PKGCONFIG_VERSION = $${SEMVER_VERSION}

## Installation targets (the pkg-config seems to install automatically)

INSTALLS += headers target
