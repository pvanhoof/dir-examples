## We get the PREFIX, MAJOR_VERSION, MINOR_VERSION, PATCH_VERSION,
## CURRENT_VERSION, REVISION_VERSION and AGE_VERSION from the 
## CMakeLists.txt at the root of the project

## The SOVERSION is ~ the API version. Usually we can take major
## and minor from semver for this.

set(CMAKE_EXAMPLE_SOVERSION ${CMAKE_EXAMPLE_MAJOR_VERSION}.${CMAKE_EXAMPLE_MINOR_VERSION})
set(CMAKE_EXAMPLE_VERSION ${CMAKE_EXAMPLE_CURRENT_VERSION}.${CMAKE_EXAMPLE_REVISION_VERSION}.${CMAKE_EXAMPLE_AGE_VERSION})

## We will use the standard add_library capability of cmake

add_library(cmake-example SHARED cmake-example.cpp)

SET_TARGET_PROPERTIES(cmake-example PROPERTIES

## According to https://autotools.io/libtool/version.html, section 4.3
## Multiple libraries versions, we should have as target-name the API
## version in the library's name. The so called SOVERSION variable is
## a perfect candidates for this.
##
## Noting that for example a project like GLib keeps the API version
## number on 2.0, while they change the minor. They say that GLib 2.4
## has a GLib 2.0 API, I guess (up to you when maintaining a library)

	         OUTPUT_NAME cmake-example-${CMAKE_EXAMPLE_SOVERSION}

## This is for the ABI version (some people refer to this as the
## libtool version. It's the part behind the .so part.

		     VERSION ${CMAKE_EXAMPLE_VERSION}

## For some reason I have to assign this property to CURRENT_VERSION
## to get somewhat reasonable outcome.
             SOVERSION ${CMAKE_EXAMPLE_CURRENT_VERSION}

## The header files to publicly install

             PUBLIC_HEADER "cmake-example.h")

## We install the library itself and we install the header
## file to a destination that is API version specific

install (TARGETS cmake-example
	         LIBRARY DESTINATION lib
             PUBLIC_HEADER DESTINATION include/cmake-example-${CMAKE_EXAMPLE_SOVERSION})

CONFIGURE_FILE("cmake-example.pc.in" "cmake-example-${CMAKE_EXAMPLE_SOVERSION}.pc" @ONLY)

