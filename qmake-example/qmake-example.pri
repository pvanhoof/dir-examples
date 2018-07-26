
## According to https://semver.org/, main page at the top, choosing
## the x.y.z in a semver version you must increment the:
##
##     o. MAJOR version when you make incompatible API changes,
##     o. MINOR version when you add functionality in a backwards-compatible manner, and
##     o. PATCH version when you make backwards-compatible bug fixes.

QMAKE_EXAMPLE_MAJOR_VERSION = 4
QMAKE_EXAMPLE_MINOR_VERSION = 3

## We are not really using PATCH_VERSION, as this should not have any
## effect on the binary or API compatibility of the resulting library.
## The PATCH_VERSION is, however, interesting for packaging for example.
## The PATCH_VERSION and the AGE_VERSION are similar in nature (and
## AGE_VERSION is being used by libtool)

QMAKE_EXAMPLE_PATCH_VERSION = 0

## According to https://autotools.io/libtool/version.html, section 4.1
## Setting the proper Shared Object Version we need to :
##
##     o. Increase the current value whenever an interface has been
##        added, removed or changed.
##     o. Always increase the revision value.
##     o. Increase the age value only if the changes made to the ABI
##        are backward compatible.
##
## For simplicity I am for now going to use the three numbers 2, 1 and 0
## for libtool's current, revision and age.
##
## The point of current, revision and age are that they form your ABI
## version (the so called VERSION). The point of major, minor (and patch)
## of semver is that it forms your API version (the so called APIVERSION).

QMAKE_EXAMPLE_CURRENT_VERSION = 3
QMAKE_EXAMPLE_REVISION_VERSION = 0
QMAKE_EXAMPLE_AGE_VERSION = 1

QMAKE_EXAMPLE_SOVERSION = $$system("echo $(($$QMAKE_EXAMPLE_CURRENT_VERSION - $$QMAKE_EXAMPLE_AGE_VERSION))")

## The libtool support in qmake assumes the VERSION variable to contain
## (current-age), age, revision. Some people think that a semver x.y.z
## numbering for VERSION is what to use (so don't get confused,
## this is for configuring the compile_libtool stuff). I'm using the
## similar variable names as in cmake here for clarity.

QMAKE_EXAMPLE_VERSION = $${QMAKE_EXAMPLE_SOVERSION}"."$${QMAKE_EXAMPLE_AGE_VERSION}"."$${QMAKE_EXAMPLE_REVISION_VERSION}

## This is just because qmake ..

isEmpty(PREFIX) {
	PREFIX = /usr
}

