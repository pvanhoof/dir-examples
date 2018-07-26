## I actually don't know how to get the APIVERSION in the target's
## names in a standardized way. I will research this further.

## I have found all sorts of hacks that make this possible. I wonder
## what the recommended and standardized way is, before using it in
## this example (as the example is about Doing It Right, not about
## hacking it like mad).

lib_LTLIBRARIES = libautotools-example-4.3.la

## Here we are passing the -version-info parameters for libtool to
## contain the current, revision and age versions

libautotools_example_4_3_la_LDFLAGS = -version-info $(AUTOTOOLS_EXAMPLE_CURRENT_VERSION):$(AUTOTOOLS_EXAMPLE_REVISION_VERSION):$(AUTOTOOLS_EXAMPLE_AGE_VERSION)
libautotools_example_4_3_la_SOURCES = autotools-example.cpp

## This installs the public headers in a API specific include path
libautotools_example_4_3includedir = $(includedir)/autotools-example-$(AUTOTOOLS_EXAMPLE_APIVERSION)
libautotools_example_4_3include_HEADERS = autotools-example.h

## This generates and installs the pkg-config file
pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = autotools-example-$(AUTOTOOLS_EXAMPLE_APIVERSION).pc

autotools-example-4.3.pc: autotools-example.pc
	cp $< $@

CLEANFILES = autotools-example-$(AUTOTOOLS_EXAMPLE_APIVERSION).pc


