## To use the APIVERSION in the target's name, use the @APIVERSION@ notation
## and not $(APIVERSION) for the variable. For some reason @VAR@ works and
## $(VAR) doesn't work for this.

lib_LTLIBRARIES = libautotools-example-@AUTOTOOLS_EXAMPLE_APIVERSION@.la

## Here we are passing the -version-info parameters for libtool to
## contain the current, revision and age versions

libautotools_example_@AUTOTOOLS_EXAMPLE_APIVERSION@_la_LDFLAGS = \
	-version-info $(AUTOTOOLS_EXAMPLE_CURRENT_VERSION):$(AUTOTOOLS_EXAMPLE_REVISION_VERSION):$(AUTOTOOLS_EXAMPLE_AGE_VERSION)

libautotools_example_@AUTOTOOLS_EXAMPLE_APIVERSION@_la_SOURCES = \
	autotools-example.cpp

## This installs the public headers in a API specific include path
libautotools_example_@AUTOTOOLS_EXAMPLE_APIVERSION@includedir = \
	$(includedir)/autotools-example-$(AUTOTOOLS_EXAMPLE_APIVERSION)

libautotools_example_@AUTOTOOLS_EXAMPLE_APIVERSION@include_HEADERS = \
	autotools-example.h

## This generates and installs the pkg-config file
pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = autotools-example-$(AUTOTOOLS_EXAMPLE_APIVERSION).pc

autotools-example-@AUTOTOOLS_EXAMPLE_APIVERSION@.pc: autotools-example.pc
	cp $< $@

CLEANFILES = autotools-example-$(AUTOTOOLS_EXAMPLE_APIVERSION).pc


