sources = ['meson-example.c']

headers = ['meson-example.h']

libmeson_example = library('meson-example-' + meson_example_api_version,
    sources,
    soversion: meson_example_soversion,
    version: meson_example_version,
    install: true,
)

configure_file(
    input: 'meson-example.pc.in',
    output: 'meson-example-@0@.pc'.format(meson_example_api_version),
    configuration: conf,
    install: true,
    install_dir: join_paths(get_option('prefix'), get_option('libdir'), 'pkgconfig'))

install_headers (headers,
    subdir: 'meson-example-@0@'.format(meson_example_api_version))
