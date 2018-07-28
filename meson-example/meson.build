## According to https://semver.org/, main page at the top, choosing
## the x.y.z in a semver version you must increment the:
##
##     o. MAJOR version when you make incompatible API changes,
##     o. MINOR version when you add functionality in a backwards-compatible manner, and
##     o. PATCH version when you make backwards-compatible bug fixes.

project('meson-example', 'c', version: '4.3.0')

cc = meson.get_compiler('c')

meson_example_major_version = meson.project_version().split('.')[0].to_int()
meson_example_minor_version = meson.project_version().split('.')[1].to_int()

## We are not really using PATCH_VERSION, as this should not have any
## effect on the binary or API compatibility of the resulting library.
## The PATCH_VERSION is, however, interesting for packaging for example.
## The PATCH_VERSION and the AGE_VERSION are similar in nature (and
## AGE_VERSION is being used by libtool)

meson_example_patch_version = meson.project_version().split('.')[2].to_int()

## According to https://autotools.io/libtool/version.html, section 4.1
## Setting the proper Shared Object Version we need to :
##
##     o. Increase the current value whenever an interface has been
##        added, removed or changed.
##     o. Always increase the revision value.
##     o. Increase the age value only if the changes made to the ABI
##        are backward compatible.
##
## For simplicity I am for now going to use the three numbers 3, 0 and 1
## for libtool's current, revision and age (this will end up as .so.2.1.0).
##
## The point of current, revision and age are that they form your ABI
## version (the so called VERSION). The point of major, minor (and patch)
## of semver is that it forms your API version (the so called APIVERSION).

meson_example_current_version = 3
meson_example_revision_version = 0
meson_example_age_version = 1

## This is to match exactly what the equivalent of libtool -version-info is

meson_example_version = '@0@.@1@.@2@'.format(meson_example_current_version - meson_example_age_version,
                                             meson_example_age_version,
                                             meson_example_revision_version)

## Usually we can take major and minor from semver for the APIVERSION.

meson_example_api_version = '@0@.@1@'.format(meson_example_major_version,
                                             meson_example_minor_version)

# soversion = current - age

meson_example_soversion = '@0@'.format(meson_example_current_version - meson_example_age_version)

conf = configuration_data()

conf.set('exec_prefix', get_option('prefix'))
conf.set('bindir', join_paths(get_option('prefix'), get_option('bindir')))
conf.set('datadir', join_paths(get_option('prefix'), get_option('datadir')))
conf.set('datarootdir', join_paths(get_option('prefix'), get_option('datadir')))
conf.set('includedir', join_paths(get_option('prefix'), get_option('includedir')))
conf.set('libdir', join_paths(get_option('prefix'), get_option('libdir')))
conf.set('libexecdir', join_paths(get_option('prefix'), get_option('libexecdir')))
conf.set('prefix', get_option('prefix'))
conf.set('MESON_EXAMPLE_API_VERSION', meson_example_api_version)
conf.set('VERSION', meson.project_version())

subdir('src')
