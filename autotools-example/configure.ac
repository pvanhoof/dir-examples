
## According to https://semver.org/, main page at the top, choosing
## the x.y.z in a semver version you must increment the:
##
##     o. MAJOR version when you make incompatible API changes,
##     o. MINOR version when you add functionality in a backwards-compatible manner, and
##     o. PATCH version when you make backwards-compatible bug fixes.


m4_define([autotools_example_major_version],    [4])
m4_define([autotools_example_minor_version],    [3])

## We are not really using PATCH_VERSION, as this should not have any
## effect on the binary or API compatibility of the resulting library.
## The PATCH_VERSION is, however, interesting for packaging for example.
## The PATCH_VERSION and the AGE_VERSION are similar in nature (and
## AGE_VERSION is being used by libtool)

m4_define([autotools_example_patch_version],    [0])

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

m4_define([autotools_example_current_version],  [3])
m4_define([autotools_example_revision_version], [0])
m4_define([autotools_example_age_version],      [1])

## What follows could be called autotools boilerplate ...

m4_define([autotools_example_semversion],
          [autotools_example_major_version.autotools_example_minor_version.autotools_example_patch_version])
m4_define([autotools_example_apiversion],
          [autotools_example_major_version.autotools_example_minor_version])

AC_INIT([autotools_example],
        [autotools_example_semversion],
        [hello@hello.com])

AM_INIT_AUTOMAKE([-Wall -Werror foreign])

## We need these to for libtool support

AM_PROG_AR
AC_PROG_LIBTOOL

## This makes the build be a bit more silent, choose no here if you want a
## lot's of command-line commands to be echod to your console while building

AM_SILENT_RULES([yes])

## We need a C++ compiler

AC_PROG_CXX

## We need to export all those version variables ...

AUTOTOOLS_EXAMPLE_MAJOR_VERSION=autotools_example_major_version
AUTOTOOLS_EXAMPLE_MINOR_VERSION=autotools_example_minor_version
AUTOTOOLS_EXAMPLE_PATCH_VERSION=autotools_example_patch_version
AUTOTOOLS_EXAMPLE_CURRENT_VERSION=autotools_example_current_version
AUTOTOOLS_EXAMPLE_REVISION_VERSION=autotools_example_revision_version
AUTOTOOLS_EXAMPLE_AGE_VERSION=autotools_example_age_version

AC_SUBST(AUTOTOOLS_EXAMPLE_MAJOR_VERSION)
AC_SUBST(AUTOTOOLS_EXAMPLE_MINOR_VERSION)
AC_SUBST(AUTOTOOLS_EXAMPLE_PATCH_VERSION)
AC_SUBST(AUTOTOOLS_EXAMPLE_CURRENT_VERSION)
AC_SUBST(AUTOTOOLS_EXAMPLE_REVISION_VERSION)
AC_SUBST(AUTOTOOLS_EXAMPLE_AGE_VERSION)

AUTOTOOLS_EXAMPLE_APIVERSION=autotools_example_apiversion
AUTOTOOLS_EXAMPLE_SEMVERSION=autotools_example_semversion

AC_SUBST(AUTOTOOLS_EXAMPLE_APIVERSION)
AC_SUBST(AUTOTOOLS_EXAMPLE_SEMVERSION)

## Let's also create a config.h file

AC_CONFIG_HEADERS([config.h])

## In autotools we need to specify which build-files and such to generate for us

AC_CONFIG_FILES([

		  Makefile
		  src/Makefile
          src/libs/Makefile
          src/libs/autotools-example/Makefile
          src/libs/autotools-example/autotools-example.pc])

AC_OUTPUT
