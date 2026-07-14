---
---

# dependency trees

**NOTE:** The information contained herein was generated using
`vcpkg depend-info <nomlib|librocket> --x-overlay-ports=$HOME/Projects/vcpkg-ports.git/ports`.

## librocket

```shell
vcpkg-cmake:
vcpkg-cmake-config:
librocket: vcpkg-cmake, vcpkg-cmake-config
```

## nomlib

```shell
nomlib
+-- librocket
|   +-- vcpkg-cmake
|   +-- vcpkg-cmake-config
+-- libsndfile
|   +-- libflac
|   |   +-- libogg
|   |   |   +-- vcpkg-cmake
|   |   |   +-- vcpkg-cmake-config
|   |   +-- vcpkg-cmake
|   |   +-- vcpkg-cmake-config
|   +-- libvorbis
|   |   +-- libogg
|   |   |   +- ...
|   |   +-- vcpkg-cmake
|   |   +-- vcpkg-cmake-config
|   +-- mp3lame
|   |   +-- vcpkg-make
|   |       +-- vcpkg-cmake-get-vars
|   |           +-- vcpkg-cmake
|   +-- mpg123
|   |   +-- vcpkg-cmake
|   |   +-- vcpkg-cmake-config
|   +-- opus
|   |   +-- vcpkg-cmake
|   |   +-- vcpkg-cmake-config
|   +-- vcpkg-cmake
|   +-- vcpkg-cmake-config
+-- openal-soft
|   +-- alsa
|   |   +-- vcpkg-make
|   |       +- ...
|   +-- fmt
|   |   +-- vcpkg-cmake
|   |   +-- vcpkg-cmake-config
|   +-- pipewire
|   |   +-- glib
|   |   |   +-- dirent
|   |   |   +-- gettext
|   |   |   |   +-- gettext-libintl
|   |   |   |   |   +-- vcpkg-make
|   |   |   |   |       +- ...
|   |   |   |   +-- libiconv
|   |   |   |       +-- vcpkg-make
|   |   |   |           +- ...
|   |   |   +-- gettext-libintl
|   |   |   |   +- ...
|   |   |   +-- libffi
|   |   |   |   +-- vcpkg-cmake-get-vars
|   |   |   |   |   +- ...
|   |   |   |   +-- vcpkg-make
|   |   |   |       +- ...
|   |   |   +-- libiconv
|   |   |   |   +- ...
|   |   |   +-- pcre2
|   |   |   |   +-- vcpkg-cmake
|   |   |   |   +-- vcpkg-cmake-config
|   |   |   +-- vcpkg-tool-meson
|   |   |   |   +-- vcpkg-cmake-get-vars
|   |   |   |       +- ...
|   |   |   +-- zlib
|   |   |       +-- vcpkg-cmake
|   |   |       +-- vcpkg-cmake-config
|   |   +-- vcpkg-tool-meson
|   |       +- ...
|   +-- vcpkg-cmake
|   +-- vcpkg-cmake-config
+-- sdl2
|   +-- dbus
|   |   +-- expat
|   |   |   +-- vcpkg-cmake
|   |   |   +-- vcpkg-cmake-config
|   |   +-- libsystemd
|   |   |   +-- gperf
|   |   |   |   +-- vcpkg-make
|   |   |   |       +- ...
|   |   |   +-- libcap
|   |   |   |   +-- vcpkg-cmake-get-vars
|   |   |   |   |   +- ...
|   |   |   |   +-- vcpkg-make
|   |   |   |       +- ...
|   |   |   +-- liblzma
|   |   |   |   +-- vcpkg-cmake
|   |   |   |   +-- vcpkg-cmake-config
|   |   |   +-- libmount
|   |   |   |   +-- vcpkg-make
|   |   |   |       +- ...
|   |   |   +-- libxcrypt
|   |   |   |   +-- vcpkg-make
|   |   |   |       +- ...
|   |   |   +-- lz4
|   |   |   |   +-- vcpkg-cmake
|   |   |   |   +-- vcpkg-cmake-config
|   |   |   +-- vcpkg-get-python-packages
|   |   |   +-- vcpkg-tool-meson
|   |   |   |   +- ...
|   |   |   +-- zstd
|   |   |       +-- vcpkg-cmake
|   |   |       +-- vcpkg-cmake-config
|   |   +-- vcpkg-cmake
|   |   +-- vcpkg-cmake-config
|   +-- vcpkg-cmake
|   +-- vcpkg-cmake-config
+-- sdl2-image
|   +-- libpng
|   |   +-- vcpkg-cmake
|   |   +-- vcpkg-cmake-config
|   |   +-- zlib
|   |       +- ...
|   +-- sdl2
|   |   +- ...
|   +-- tiff
|   |   +-- libjpeg-turbo
|   |   |   +-- vcpkg-cmake
|   |   |   +-- vcpkg-cmake-config
|   |   +-- liblzma
|   |   |   +- ...
|   |   +-- vcpkg-cmake
|   |   +-- vcpkg-cmake-config
|   |   +-- zlib
|   |       +- ...
|   +-- vcpkg-cmake
|   +-- vcpkg-cmake-config
+-- sdl2-ttf
|   +-- freetype
|   |   +-- brotli
|   |   |   +-- vcpkg-cmake
|   |   |   +-- vcpkg-cmake-config
|   |   +-- bzip2
|   |   |   +-- vcpkg-cmake
|   |   +-- libpng
|   |   |   +- ...
|   |   +-- vcpkg-cmake
|   |   +-- vcpkg-cmake-config
|   |   +-- zlib
|   |       +- ...
|   +-- sdl2
|   |   +- ...
|   +-- vcpkg-cmake
|   +-- vcpkg-cmake-config
+-- vcpkg-cmake
+-- vcpkg-cmake-config
```

