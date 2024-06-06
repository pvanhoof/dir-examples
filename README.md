# Doing It Right examples

The DIR examples are examples for various build environments on how to create a good project structure that will build libraries that are versioned with libtool or have versioning that is equivalent to what libtool would deliver, have a pkg-config file and have a so called API version in the library's name.

The word DIR here doesn't come from MS-DOS's DIR command but comes instead from [Doing It Right (scuba diving)](https://en.wikipedia.org/wiki/Doing_It_Right_(scuba_diving)). When doing Scuba diving wrong, the consequences can be spectacular (you and your buddies can die and more importantly you can disturb or damage the surroundings). When doing libraries wrong, software that depends on your library can crash and go spectacularly wrong too. Doing It Right is therefor a good idea.

## What is right?

Information on this can be found in the [autotools mythbuster docs](https://autotools.io/libtool/version.html), the [libtool docs on versioning](https://www.gnu.org/software/libtool/manual/libtool.html#Libtool-versioning) and [freeBSD's chapter on shared libraries](https://www.freebsd.org/doc/en/books/developers-handbook/policies-shlib.html). I tried to ensure that what is written here works with all of the build environments in the examples.

### libpackage-4.3.so.2.1.0, what is what?

You'll notice that a library called 'package' will in your LIBDIR often be called something like libpackage-4.3.so.2.1.0

We call the 4.3 part the APIVERSION, and the 2.1.0 part the VERSION (the ABI version).

I will explain these examples using [semantic versioning](https://semver.org) as APIVERSION and either libtool's current:revision:age or a [semantic versioning](https://semver.org) alternative as field for VERSION (like in FreeBSD and for build environments where compatibility with [libtool's -version-info feature](https://www.gnu.org/software/libtool/manual/libtool.html#Libtool-versioning) ain't a requirement).

Noting that with [libtool's -version-info feature](https://www.gnu.org/software/libtool/manual/libtool.html#Libtool-versioning) the values that you fill in for current, age and revision will not necessarily be identical to what ends up as suffix of the soname in LIBDIR. The formula to form the filename's suffix is, for libtool, "(current - age).age.revision". This means that for soname libpackage-APIVERSION.so.2.1.0, you would need current=3, revision=0 and age=1.

### The VERSION part

In case you want compatibility with or use [libtool's -version-info feature](https://www.gnu.org/software/libtool/manual/libtool.html#Libtool-versioning), the document [libtool/version.html](https://autotools.io/libtool/version.html) on [autotools.io](https://autotools.io) states:

> The rules of thumb, when dealing with these values are:
> 
> * Increase the current value whenever an interface has been added, removed or changed.
> * Always increase the revision value.
> * Increase the age value only if the changes made to the ABI are backward compatible.

The [libtool's -version-info feature](https://www.gnu.org/software/libtool/manual/libtool.html#Libtool-versioning)'s [updating-version-info part of libtool's docs](https://www.gnu.org/software/libtool/manual/libtool.html#Updating-version-info) states:

> 1. Start with version information of ‘0:0:0’ for each libtool library.
> 2. Update the version information only immediately before a public release of your software. More frequent updates are unnecessary, and only guarantee that the current interface number gets larger faster.
> 3. If the library source code has changed at all since the last update, then increment revision (‘c:r:a’ becomes ‘c:r+1:a’).
> 4. If any interfaces have been added, removed, or changed since the last update, increment current, and set revision to 0.
> 5. If any interfaces have been added since the last public release, then increment age.
> 6. If any interfaces have been removed or changed since the last public release, then set age to 0.

When you don't care about compatibility with [libtool's -version-info feature](https://www.gnu.org/software/libtool/manual/libtool.html#Libtool-versioning), then you can take the following simplified rules for VERSION:

> * SOVERSION = Major version
> * Major version: increase it if you break ABI compatibility
> * Minor version: increase it if you add ABI compatible features
> * Patch version: increase it for bug fix releases.

Examples when these simplified rules are or can be applicable is in build environments like cmake, meson and qmake. When you use autotools you will be using libtool and then they ain't applicable.

### The APIVERSION part

For the API version I will use the rules from [semver.org](https://semver.org). You can also use the semver rules for your package's version:

> Given a version number MAJOR.MINOR.PATCH, increment the:
> 
> 1. MAJOR version when you make incompatible API changes,
> 2. MINOR version when you add functionality in a backwards-compatible manner, and
> 3. PATCH version when you make backwards-compatible bug fixes.

When you have an API, that API can change over time. You typically want to version those API changes so that the users of your library can adopt to newer versions of the API while at the same time other users still use older versions of your API. For this we can follow section 4.3. called "multiple libraries versions" of the [autotools mythbuster documentation](https://autotools.io/libtool/version.html). It states:

> In this situation, the best option is to append part of the library's version information to the library's name, which is exemplified by Glib's libglib-2.0.so.0 > soname. To do so, the declaration in the Makefile.am has to be like this:
> 
>     lib_LTLIBRARIES = libtest-1.0.la
>     
>     libtest_1_0_la_LDFLAGS = -version-info 0:0:0

### The pkg-config file

Many people use many build environments (autotools, qmake, cmake, meson, you name it). Nowadays almost all of those build environments support pkg-config out of the box. Both for generating the file as for consuming the file for getting information about dependencies.

I consider it a necessity to ship with a useful and correct pkg-config .pc file. The filename should be /usr/lib/pkgconfig/package-APIVERSION.pc for soname libpackage-APIVERSION.so.VERSION. In our example that means /usr/lib/pkgconfig/package-4.3.pc. We'd use the command pkg-config package-4.3 --cflags --libs, for example.

Examples are GLib's pkg-config file, located at /usr/lib/pkgconfig/glib-2.0.pc

### The include path

I consider it a necessity to ship API headers in a per API-version different location (like for example GLib's, at /usr/include/glib-2.0). This means that your API version number must be part of the include-path.

For example using earlier mentioned API-version 4.3, /usr/include/package-4.3 for /usr/lib/libpackage-4.3.so(.2.1.0) having /usr/lib/pkg-config/package-4.3.pc

## What will the linker typically link with?

The linker will for -lpackage-4.3 typically link with /usr/lib/libpackage-4.3.so.2 or with libpackage-APIVERSION.so.(current - age). Noting that the part that is calculated as (current - age) in this example is often, for example in cmake and meson, referred to as the SOVERSION. With SOVERSION the soname template in LIBDIR is libpackage-APIVERSION.so.SOVERSION.

## What is wrong?

### Not doing any versioning

Without versioning you can't make any API or ABI changes that wont break all your users' code in a way that could be managable for them. If you do decide not to do any versioning, then at least also don't put anything behind the .so part of your so's filename. That way, at least you wont break things in spectacular ways.

### Coming up with your own versioning scheme

Knowing it better than the rest of the world will in spectacular ways make everything you do break with what the entire rest of the world does. You shouldn't congratulate yourself with that. The only thing that can be said about it is that it probably makes little sense, and that others will probably start ignoring your work. Your mileage may vary. Keep in mind that without a correct SOVERSION, certain things will simply not work correct.

### In case of libtool: using your package's (semver) release numbering for current, revision, age

This is similarly wrong to 'Coming up with your own versioning scheme'.

The [Libtool documentation on updating version info](https://www.gnu.org/software/libtool/manual/libtool.html#Updating-version-info) is clear about this:

> Never try to set the interface numbers so that they correspond to the release number of your package. This is an abuse that only fosters misunderstanding of the purpose of library versions.

This basically means that once you are using libtool, also use libtool's versioning rules.

### Refusing or forgetting to increase the current and/or SOVERSION on breaking ABI changes

The current part of the VERSION (current, revision and age) minus age, or, SOVERSION is/are the most significant field(s). The current and age are usually involved in forming the so called SOVERSION, which in turn is used by the linker to know with which ABI version to link. That makes it ... damn important.

Some people think 'all this is just too complicated for me', 'I will just refuse to do anything and always release using the same version numbers'. That goes spectacularly wrong whenever you made ABI incompatible changes. It's similarly wrong to 'Coming up with your own versioning scheme'.

That way, all programs that link with your shared library can after your shared library gets updated easily crash, can corrupt data and might or might not work.

By updating the current and age, or, SOVERSION you will basically trigger people who manage packages and their tooling to rebuild programs that link with your shared library. You actually want that the moment you made breaking ABI changes in a newer version of it.

When you don't want to care about [libtool's -version-info feature](https://www.gnu.org/software/libtool/manual/libtool.html#Libtool-versioning), then there is also a set of more simple to follow rules. Those rules are for VERSION:

> * SOVERSION = Major version (with these simplified set of rules, no subtracting of current with age is needed)
> * Major version: increase it if you break ABI compatibility
> * Minor version: increase it if you add ABI compatible features
> * Patch version: increase it for bug fix releases.

## What isn't wrong?

### Not using libtool (but nonetheless doing ABI versioning right)

GNU libtool was made to make certain things more easy. Nowadays many popular build environments also make things more easy. Meanwhile has GNU libtool been around for a long time. And its versioning rules, commonly known as the current:revision:age field as parameter for -version-info, got widely adopted.

What GNU libtool did was, however, not really a standard. It is one interpretation of how to do it. And a rather complicated one, at that.

Please let it be crystal clear that not using libtool does not mean that you can do ABI versioning wrong. Because very often people seem to think that they can, and think they'll still get out safely while doing ABI versioning completely wrong. This is not the case.

### Not having a APIVERSION at all

It isn't wrong not to have an APIVERSION in the soname. It however means that you promise to not ever break API. Because the moment you break API, you disallow your users to stay on the old API for a little longer. They might both have programs that use the old and that use the new API. Now what?

When you have an APIVERSION then you can allow the introduction of a new version of the API while simultaneously the old API remains available on a user's system.

### Using a different naming-scheme for APIVERSION

I used the MAJOR.MINOR version numbers from semver to form the APIVERSION. I did this because only the MAJOR and the MINOR are technically involved in API changes (unless you are doing semantic versioning wrong - in which case see 'Coming up with your own versioning scheme').

Some projects only use MAJOR. Examples are Qt which puts the MAJOR number behind the Qt part. For example libQt5Core.so.VERSION (so that's "Qt" + MAJOR + Module). The GLib world, however, uses "g" + Module + "-" + MAJOR + ".0" as they have releases like 2.2, 2.3, 2.4 that are all called libglib-2.0.so.VERSION. I guess they figured that maybe someday in their 2.x series, they could use that MINOR field?

DBus seems to be using a similar thing to GLib, but then without the MINOR suffix: libdbus-1.so.VERSION. For their GLib integration they also use it as libdbus-glib-1.so.VERSION.

Who is right, who is wrong? It doesn't matter too much for your APIVERSION naming scheme. As long as there is a way to differentiate the API in a) the include path, b) the pkg-config filename and c) the library that will be linked with (the -l parameter during linking/compiling). Maybe someday a standard will be defined? Let's hope so.

## Differences in interpretation per platform

### FreeBSD

FreeBSD's [Shared Libraries of Chapter 5. Source Tree Guidelines and Policies](https://www.freebsd.org/doc/en/books/developers-handbook/policies-shlib.html) states:

> The three principles of shared library building are:
> 1. Start from 1.0
> 2. If there is a change that is backwards compatible, bump minor number (note that ELF systems ignore the minor number)
> 3. If there is an incompatible change, bump major number
> 
> For instance, added functions and bugfixes result in the minor version number being bumped, while deleted functions, changed function call syntax, etc. will force the major version number to change.

I think that when using libtool on a FreeBSD (when you use autotools), that the platform will provide a variant of libtool's scripts that will convert earlier mentioned current, revision and age rules to FreeBSD's. Meaning that with autotools, you can just use the rules for GNU libtool's -version-info.

I could be wrong on this, but I did find mailing list E-mails from ~ 2011 stating that this SNAFU is dealt with. Besides, the *BSD porters otherwise know what to do and you could of course always ask them about it.

Note that FreeBSD's rules are or seem to be compatible with the rules for VERSION when you don't want to care about libtool's -version-info compatibility. However, when you are porting from a libtoolized project, then of course you don't want to let newer releases break against releases that have already happened.

### Modern Linux distributions

Nowadays you sometimes see things like /usr/lib/$ARCH/libpackage-APIVERSION.so linking to /lib/$ARCH/libpackage-APIVERSION.so.VERSION. I have no idea how this mechanism works. I suppose this is being done by packagers of various Linux distributions? I also don't know if there is a standard for this.

I will update the examples and this document the moment I know more and/or if upstream developers need to worry about it. I think that using GNUInstallDirs in cmake, for example, makes everything go right. I have not found much for this in qmake, meson seems to be doing this by default and in autotools you always use platform variables for such paths.

As usual, I hope standards will be made and that the build environment and packaging community gets to their senses and stops leaving this into the hands of developers. I especially think about qmake, which seems to not have much at all to state that standardized installation paths must be used (not even a proper way to define a prefix).

## Questions that I can imagine already exist

### Why is there there a difference between APIVERSION and VERSION?

The API version is the version of your programmable interfaces. This means the version of your header files (if your programming language has such header files), the version of your pkgconfig file, the version of your documentation. The API is what software developers need to utilize your library.

The ABI version can definitely be different and it is what programs that are compiled and installable need to utilize your library.

An API breaks when recompiling the program without any changes, that consumes a libpackage-4.3.so.2, is not going to succeed at compile time. The API got broken the moment any possible way package's API was used, wont compile. Yes, any way. It means that a libpackage-5.0.so.0 should be started.

An ABI breaks when without recompiling the program, replacing a libpackage-4.3.so.2.1.0 with a libpackage-4.3.so.2.2.0 or a libpackage-4.3.so.2.1.1 (or later) as libpackage-4.3.so.2 is not going to succeed at runtime. For example because it would crash, or because the results would be wrong (in any way). It implies that libpackage-4.3.so.2 shouldn't be overwritten, but libpackage-4.3.so.3 should be started.

For example when you change the parameter of a function in C to be a floating point from a integer (and/or the other way around), then that's an ABI change but not neccesarily an API change.

### What is this SOVERSION about?

In most projects that got ported from an environment that uses GNU libtool (for example autotools) to for example cmake or meson, and in the rare cases that they did anything at all in a qmake based project, I saw people converting the current, revision and age parameters that they passed to the -version-info option of libtool to a string concatenated together using (current - age), age, revision as VERSION, and (current - age) as SOVERSION.

I wanted to use the exact same rules for versioning for all these examples, including autotools and GNU libtool. When you don't have to (or want to) care about libtool's set of (for some people, needlessly complicated) -version-info rules, then it should be fine using just SOVERSION and VERSION using these rules:

> * SOVERSION = Major version
> * Major version: increase it if you break ABI compatibility
> * Minor version: increase it if you add ABI compatible features
> * Patch version: increase it for bug fix releases.

I, however, also sometimes saw variations that are incomprehensible with little explanation and magic foo invented on the spot. Those variations are probably wrong.

In the example I made it so that in the root build file of the project you can change the numbers and calculation for the numbers. However. Do follow the rules for those correctly, as this versioning is about ABI compatibility. Doing this wrong can make things blow up in spectacular ways.

## The examples

### qmake in the qmake-example

Note that the VERSION variable must be filled in as "(current - age).age.revision" for qmake (to get 2.1.0 at the end, you need VERSION=2.1.0 when current=3, revision=0 and age=1)

To try this example out, go to the qmake-example directory and type

    $ cd qmake-example
    $ mkdir=_test
    $ qmake PREFIX=$PWD/_test
    $ make
    $ make install
 
This should give you this:

    $ find _test/
    _test/
    ├── include
    │   └── qmake-example-4.3
    │       └── qmake-example.h
    └── lib
        ├── libqmake-example-4.3.so -> libqmake-example-4.3.so.2.1.0
        ├── libqmake-example-4.3.so.2 -> libqmake-example-4.3.so.2.1.0
        ├── libqmake-example-4.3.so.2.1 -> libqmake-example-4.3.so.2.1.0
        ├── libqmake-example-4.3.so.2.1.0
        ├── libqmake-example-4.la
        └── pkgconfig
            └── qmake-example-4.3.pc

When you now use pkg-config, you get a nice CFLAGS and LIBS line back (I'm replacing the current path with $PWD in the output each time):

    $ export PKG_CONFIG_PATH=$PWD/_test/lib/pkgconfig
    $ pkg-config qmake-example-4.3 --cflags
    -I$PWD/_test/include/qmake-example-4.3
    $ pkg-config qmake-example-4.3 --libs
    -L$PWD/_test/lib -lqmake-example-4.3

And it means that you can do things like this now (and people who know about pkg-config will now be happy to know that they can use your library in their own favorite build environment).

    $ export LD_LIBRARY_PATH=$PWD/_test/lib
    $ echo -en "#include <qmake-example.h>\nmain() {} " > test.cpp
    $ g++ -fPIC test.cpp -o test.o `pkg-config qmake-example-4.3 --libs --cflags`

You can see that it got linked to libqmake-example-4.3.so.2, where that 2 at the end is (current - age).

    $ ldd test.o 
        linux-gate.so.1 (0xb77b0000)
        libqmake-example-4.3.so.2 => $PWD/_test/lib/libqmake-example-4.3.so.2 (0xb77a6000)
        libstdc++.so.6 => /usr/lib/i386-linux-gnu/libstdc++.so.6 (0xb75f5000)
        libm.so.6 => /lib/i386-linux-gnu/libm.so.6 (0xb759e000)
        libgcc_s.so.1 => /lib/i386-linux-gnu/libgcc_s.so.1 (0xb7580000)
        libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0xb73c9000)
        /lib/ld-linux.so.2 (0xb77b2000)

### cmake in the cmake-example

Note that the VERSION property on your library target must be filled in with "(current - age).age.revision" for cmake (to get 2.1.0 at the end, you need VERSION=2.1.0 when current=3, revision=0 and age=1. Note that in cmake you must also fill in the SOVERSION property as (current - age), so SOVERSION=2 when current=3 and age=1).

To try this example out, go to the cmake-example directory and do

    $ cd cmake-example
    $ mkdir _test
    $ cmake -DCMAKE_INSTALL_PREFIX:PATH=$PWD/_test
    -- Configuring done
    -- Generating done
    -- Build files have been written to: .
    $ make
    [ 50%] Building CXX object src/libs/cmake-example/CMakeFiles/cmake-example.dir/cmake-example.cpp.o
    [100%] Linking CXX shared library libcmake-example-4.3.so
    [100%] Built target cmake-example
    $ make install
    [100%] Built target cmake-example
    Install the project...
    -- Install configuration: ""
    -- Installing: $PWD/_test/lib/libcmake-example-4.3.so.2.1.0
    -- Up-to-date: $PWD/_test/lib/libcmake-example-4.3.so.2
    -- Up-to-date: $PWD/_test/lib/libcmake-example-4.3.so
    -- Up-to-date: $PWD/_test/include/cmake-example-4.3/cmake-example.h
    -- Up-to-date: $PWD/_test/lib/pkgconfig/cmake-example-4.3.pc

This should give you this:

    $ tree _test/
    _test/
    ├── include
    │   └── cmake-example-4.3
    │       └── cmake-example.h
    └── lib
        ├── libcmake-example-4.3.so -> libcmake-example-4.3.so.2
        ├── libcmake-example-4.3.so.2 -> libcmake-example-4.3.so.2.1.0
        ├── libcmake-example-4.3.so.2.1.0
        └── pkgconfig
            └── cmake-example-4.3.pc

When you now use pkg-config, you get a nice CFLAGS and LIBS line back (I'm replacing the current path with $PWD in the output each time):

    $ pkg-config cmake-example-4.3 --cflags
    -I$PWD/_test/include/cmake-example-4.3
    $ pkg-config cmake-example-4.3 --libs
    -L$PWD/_test/lib -lcmake-example-4.3

And it means that you can do things like this now (and people who know about pkg-config will now be happy to know that they can use your library in their own favorite build environment):

    $ echo -en "#include <cmake-example.h>\nmain() {} " > test.cpp
    $ g++ -fPIC test.cpp -o test.o `pkg-config cmake-example-4.3 --libs --cflags`

You can see that it got linked to libcmake-example-4.3.so.2, where that 2 at the end is the SOVERSION. This is (current - age).

    $ ldd test.o
        linux-gate.so.1 (0xb7729000)
        libcmake-example-4.3.so.2 => $PWD/_test/lib/libcmake-example-4.3.so.2 (0xb771f000)
        libstdc++.so.6 => /usr/lib/i386-linux-gnu/libstdc++.so.6 (0xb756e000)
        libm.so.6 => /lib/i386-linux-gnu/libm.so.6 (0xb7517000)
        libgcc_s.so.1 => /lib/i386-linux-gnu/libgcc_s.so.1 (0xb74f9000)
        libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0xb7342000)
        /lib/ld-linux.so.2 (0xb772b000)

### autotools in the autotools-example

Note that you pass -version-info current:revision:age directly with autotools. The libtool will translate that to (current - age).age.revision to form the so's filename (to get 2.1.0 at the end, you need current=3, revision=0, age=1).

To try this example out, go to the autotools-example directory and do

    $ cd autotools-example
    $ mkdir _test
    $ libtoolize
    $ aclocal
    $ autoheader
    $ autoconf
    $ automake --add-missing
    $ ./configure --prefix=$PWD/_test
    $ make
    $ make install

This should give you this:

    $ tree _test/
    _test/
    ├── include
    │   └── autotools-example-4.3
    │       └── autotools-example.h
    └── lib
        ├── libautotools-example-4.3.a
        ├── libautotools-example-4.3.la
        ├── libautotools-example-4.3.so -> libautotools-example-4.3.so.2.1.0
        ├── libautotools-example-4.3.so.2 -> libautotools-example-4.3.so.2.1.0
        ├── libautotools-example-4.3.so.2.1.0
        └── pkgconfig
            └── autotools-example-4.3.pc

When you now use pkg-config, you get a nice CFLAGS and LIBS line back (I'm replacing the current path with $PWD in the output each time):

    $ export PKG_CONFIG_PATH=$PWD/_test/lib/pkgconfig
    $ pkg-config autotools-example-4.3 --cflags
    -I$PWD/_test/include/autotools-example-4.3
    $ pkg-config autotools-example-4.3 --libs
    -L$PWD/_test/lib -lautotools-example-4.3

And it means that you can do things like this now (and people who know about pkg-config will now be happy to know that they can use your library in their own favorite build environment):

    $ echo -en "#include <autotools-example.h>\nmain() {} " > test.cpp
    $ export LD_LIBRARY_PATH=$PWD/_test/lib
    $ g++ -fPIC test.cpp -o test.o `pkg-config autotools-example-4.3 --libs --cflags`

You can see that it got linked to libautotools-example-4.3.so.2, where that 2 at the end is (current - age).

    $ ldd test.o 
        linux-gate.so.1 (0xb778d000)
        libautotools-example-4.3.so.2 => $PWD/_test/lib/libautotools-example-4.3.so.2 (0xb7783000)
        libstdc++.so.6 => /usr/lib/i386-linux-gnu/libstdc++.so.6 (0xb75d2000)
        libm.so.6 => /lib/i386-linux-gnu/libm.so.6 (0xb757b000)
        libgcc_s.so.1 => /lib/i386-linux-gnu/libgcc_s.so.1 (0xb755d000)
        libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0xb73a6000)
        /lib/ld-linux.so.2 (0xb778f000)

### meson in the meson-example

Note that the version property on your library target must be filled in with "(current - age).age.revision" for meson (to get 2.1.0 at the end, you need version=2.1.0 when current=3, revision=0 and age=1. Note that in meson you must also fill in the soversion property as (current - age), so soversion=2 when current=3 and age=1).

To try this example out, go to the meson-example directory and do

    $ cd meson-example
    $ mkdir -p _build/_test
    $ cd _build
    $ meson .. --prefix=$PWD/_test
    $ ninja
    $ ninja install

This should give you this:

    $ tree _test/
    _test/
    ├── include
    │   └── meson-example-4.3
    │       └── meson-example.h
    └── lib
        └── i386-linux-gnu
            ├── libmeson-example-4.3.so -> libmeson-example-4.3.so.2.1.0
            ├── libmeson-example-4.3.so.2 -> libmeson-example-4.3.so.2.1.0
            ├── libmeson-example-4.3.so.2.1.0
            └── pkgconfig
                └── meson-example-4.3.pc

When you now use pkg-config, you get a nice CFLAGS and LIBS line back (I'm replacing the current path with $PWD in the output each time):

    $ export PKG_CONFIG_PATH=$PWD/_test/lib/i386-linux-gnu/pkgconfig
    $ pkg-config meson-example-4.3 --cflags
    -I$PWD/_test/include/meson-example-4.3
    $ pkg-config meson-example-4.3 --libs
    -L$PWD/_test/lib -lmeson-example-4.3

And it means that you can do things like this now (and people who know about pkg-config will now be happy to know that they can use your library in their own favorite build environment):

    $ echo -en "#include <meson-example.h>\nmain() {} " > test.cpp
    $ export LD_LIBRARY_PATH=$PWD/_test/lib/i386-linux-gnu
    $ g++ -fPIC test.cpp -o test.o `pkg-config meson-example-4.3 --libs --cflags`

You can see that it got linked to libmeson-example-4.3.so.2, where that 2 at the end is the soversion. This is (current - age).

    $ ldd test.o 
        linux-gate.so.1 (0xb772e000)
        libmeson-example-4.3.so.2 => $PWD/_test/lib/i386-linux-gnu/libmeson-example-4.3.so.2 (0xb7724000)
        libstdc++.so.6 => /usr/lib/i386-linux-gnu/libstdc++.so.6 (0xb7573000)
        libm.so.6 => /lib/i386-linux-gnu/libm.so.6 (0xb751c000)
        libgcc_s.so.1 => /lib/i386-linux-gnu/libgcc_s.so.1 (0xb74fe000)
        libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0xb7347000)
        /lib/ld-linux.so.2 (0xb7730000)

## OMG, there is something wrong in these examples

Especially if you are a developer on or a maintainer of one of the build environments being explained here, I'm very interested in your feedback.

I'm also absolutely willing to improve the example of your build environment. You can either send me a mail and wait for me to improve it myself, make a pull request or send me format-patch diffs.

If you want to add your build environment to the examples, this is also possible. Noting that you should (try to) achieve all that the other examples also achieve.

If you disagree with something I wrote here, then please contact me and provide me with good argumentation with clear references to documentation and statements that are bleached from opinions. Or at least try to reach the same level of referencing and technical explaining that I did myself here. I also hope that instead of just having an opinion you will contact the maintainer and/or official mailing-list of the affected build environment.

Note that in this matter there are more opinions than there is knowledge. There are also many very good practical reasons why certain things are what they are. You'll need to bring a serious amount of good technical argumentation to the table.

This does not mean that you can't have an impact. In fact, it means it's more easy to have an impact: be technically well informed. This is much more easy than opinions and politics.


