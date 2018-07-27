## We get the CMAKE_EXAMPLE_MAJOR_VERSION, CMAKE_EXAMPLE_MINOR_VERSION,
## CMAKE_EXAMPLE_PATCH_VERSION, CMAKE_EXAMPLE_CURRENT_VERSION,
## CMAKE_EXAMPLE_REVISION_VERSION, CMAKE_EXAMPLE_AGE_VERSION and we
## also get CMAKE_EXAMPLE_SOVERSION and CMAKE_EXAMPLE_APIVERSION from
## the CMakeLists.txt at the root of the project

## We will use the standard add_library capability of cmake

add_library(cmake-example SHARED cmake-example.cpp)

SET_TARGET_PROPERTIES(cmake-example PROPERTIES

## According to https://autotools.io/libtool/version.html, section 4.3
## Multiple libraries versions, we should have as target-name the API
## version in the library's name. The so called APIVERSION variable is
## a perfect candidate to use for this purpose.
##
## Noting that for example a project like GLib keeps the API version
## number on 2.0, while they change the minor. They say that GLib 2.4
## has a GLib 2.0 API, I guess (up to you when maintaining a library)

             OUTPUT_NAME cmake-example-${CMAKE_EXAMPLE_APIVERSION}

## This is for the ABI version (some people refer to this as the
## libtool -version-info version. It's the part behind the .so part.
## It's calculated as (current - age).age.revision.

             VERSION ${CMAKE_EXAMPLE_VERSION}

## The SOVERSION is calculated as (current - age) in cmake

             SOVERSION ${CMAKE_EXAMPLE_SOVERSION}

## The header files to publicly install

             PUBLIC_HEADER "cmake-example.h")

## We install the library itself and we install the header file to a
## destination that is API version specific

install (TARGETS cmake-example

## This installs our library to the lib directory (typically /usr/lib)

             LIBRARY DESTINATION lib

## This installs our library's headers to a API version specific location

             PUBLIC_HEADER DESTINATION include/cmake-example-${CMAKE_EXAMPLE_APIVERSION})

## This generates the pkg-config file as cmake-example-4.3.pc

CONFIGURE_FILE("cmake-example.pc.in" "cmake-example-${CMAKE_EXAMPLE_APIVERSION}.pc" @ONLY)

## This installs the pkg-config file to the right location

set(INSTALL_PKGCONFIG_DIR "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig"
             CACHE PATH "Installation directory for pkgconfig (.pc) files")

install(FILES cmake-example-${CMAKE_EXAMPLE_APIVERSION}.pc
             DESTINATION "${INSTALL_PKGCONFIG_DIR}")

