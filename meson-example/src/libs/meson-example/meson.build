pkg = import('pkgconfig')

sources = ['meson-example.c']

headers = ['meson-example.h']

libmeson_example = library('meson-example-' + meson_example_api_version,
    sources,
    soversion: meson_example_soversion,
    version: meson_example_version,
    install: true,
)

pkg.generate(
    filebase: 'meson-example-' + meson_example_api_version,
    version: meson.project_version(),
    name: 'meson-example',
    subdirs: 'meson-example-' + meson_example_api_version,
    description: 'A library demostrating doing it right in meson',
    libraries: libmeson_example
)

install_headers (headers,
    subdir: 'meson-example-@0@'.format(meson_example_api_version))
