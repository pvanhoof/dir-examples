cmake_minimum_required (VERSION 2.8.11)
project (cmake-example)

## According to https://semver.org/, main page at the top, choosing
## the x.y.z in a semver version you must increment the:
##
##     o. MAJOR version when you make incompatible API changes,
##     o. MINOR version when you add functionality in a backwards-compatible manner, and
##     o. PATCH version when you make backwards-compatible bug fixes.

set(CMAKE_EXAMPLE_MAJOR_VERSION 4)
set(CMAKE_EXAMPLE_MINOR_VERSION 3)

## We are not really using PATCH_VERSION, as this should not have any
## effect on the binary or API compatibility of the resulting library.
## The PATCH_VERSION is, however, interesting for packaging for example.
## The PATCH_VERSION and the AGE_VERSION are similar in nature (and
## AGE_VERSION is being used by libtool)

set(CMAKE_EXAMPLE_PATCH_VERSION 0)

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

set(CMAKE_EXAMPLE_CURRENT_VERSION 3)
set(CMAKE_EXAMPLE_REVISION_VERSION 0)
set(CMAKE_EXAMPLE_AGE_VERSION 1)

## This is to match exactly what the equivalent of libtool -version-info is

# soversion = current - age
math(EXPR CMAKE_EXAMPLE_SOVERSION "${CMAKE_EXAMPLE_CURRENT_VERSION} - ${CMAKE_EXAMPLE_AGE_VERSION}")

# version to pass as VERSION is (current - age).age.revision
set(CMAKE_EXAMPLE_VERSION ${CMAKE_EXAMPLE_SOVERSION}.${CMAKE_EXAMPLE_AGE_VERSION}.${CMAKE_EXAMPLE_REVISION_VERSION})

## The APIVERSION is ~ the API version. Usually we can take major
## and minor from semver for this.

set(CMAKE_EXAMPLE_APIVERSION ${CMAKE_EXAMPLE_MAJOR_VERSION}.${CMAKE_EXAMPLE_MINOR_VERSION})


 
add_subdirectory (src)
