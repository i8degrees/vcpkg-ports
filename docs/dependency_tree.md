---
---

# dependency trees

**NOTE:** The information contained herein was generated using
`vcpkg depend-info <nomlib|librocket> --x-overlay-ports=$HOME/Projects/vcpkg-ports.git/ports`.
Last updated: 2026-11-18.

## librocket

```shell
vcpkg depend-info librocket --format=tree --x-overlay-ports=./ports

librocket
+-- vcpkg-cmake
+-- vcpkg-cmake-config
```

## nomlib

```shell
vcpkg depend-info nomlib --format=tree --x-overlay-ports=./ports

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
|   |   |   |   +-- vcpkg-cmake-get-vars
|   |   |   |       +- ...
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
|   |       +-- vcpkg-cmake
|   |       +-- vcpkg-cmake-config
|   +-- sdl2
|   |   +- ...
|   +-- tiff
|   |   +-- libjpeg-turbo
|   |   |   +-- libspng
|   |   |   |   +-- vcpkg-cmake
|   |   |   |   +-- vcpkg-cmake-config
|   |   |   |   +-- zlib
|   |   |   |       +- ...
|   |   |   +-- vcpkg-cmake
|   |   |   +-- vcpkg-cmake-config
|   |   |   +-- zlib
|   |   |       +- ...
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
