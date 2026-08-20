# vcpkg ports

My private vcpkg registry for ports that have not been published [upstream][0].

- ports
    - `librocket` - v1.3.0.0 (upstream)

## usage

- see also
    - [vcpkg: publish to a git repository](https://learn.microsoft.com/en-us/vcpkg/produce/publish-to-a-git-registry)
    - [vcpkg concepts: registries](https://learn.microsoft.com/en-us/vcpkg/concepts/registries)
    - [vcpkg: handling usage files](https://learn.microsoft.com/en-us/vcpkg/maintainers/handling-usage-files)
    - [vcpkg: vcpkg.json platforms ref](https://learn.microsoft.com/en-us/vcpkg/reference/vcpkg-json#platform-expression)

### export SDK

**NOTE(JEFF):** This note assumes manifest mode and should be done at the
top-level of the project with the `vcpkg.json` manifest.

```shell
# Package the installed dependencies in a zip archive at export.zip
## static library archives, .a|.dll.a
vcpkg export --output-dir=. --zip --output=x64-mingw-static --host-triplet=x64-mingw-static
```

```shell
## dynamic (shared) libraries, .dll|.lib|.dylib
vcpkg export --output-dir=. --zip --output=x64-mingw-dynamic --host-triplet=x64-mingw-dynamic
```

```shell
# specify the dependency input path (a dir) - existing vcpkg_installed
# dir with vcpkg deps
vcpkg export --zip --output-dir=. --host-triplet=x64-mingw-static --x-install-root=c:/temp/debug-win/vcpkg_installed
```

```shell
# reuse 
CMAKE_TOOLCHAIN_FILE=./x64-mingw-dynamic/vcpkg/scripts/buildsystems/vcpkg.cmake
```

### development

```shell
vcpkg edit librocket --vcpkg-root .
```

### finding packages

- [vcpkg.io][100]

### dependency trees

```shell
# plain text output
vcpkg depend-info nomlib --x-overlay-ports=/home/jeff/Projects/vcpkg-ports.git/ports
```

```shell
# Visual hierarchy of dependency tree for a port
vcpkg depend-info <port-name> --format=tree
#vcpkg depend-info nomlib --format=tree --x-overlay-ports=/home/jeff/Projects/vcpkg-ports.git/ports
```

### usage text

**NOTE(JEFF):** This only works on M$ Windows as of this writing :-/

```shell
vcpkg print-usage <port>
```

### env

**NOTE(JEFF):** This command is only applicable for when you are using vcpkg
on the Windows platform.

Initialize env similar to what is setup for you when you use the developer
console on Windows; this shortcut is available once you have installed the
**Visual Studio Build Tools**.

```shell
# similar to vcvarsall.bat
vcpkg env
```

### testing

```shell
# The directory path of the given overlay ports should be adjusted for your
# site
vcpkg remove <port> --x-overlay-ports=$HOME/Projects/vcpkg-ports.git/ports
vcpkg install <port> --x-overlay-ports=$HOME/Projects/vcpkg-ports.git/ports
```

### validation of port manifest files

After any modifications made to a port manifest -- `vcpkg.json` -- one should
always validate the changes using the `format-manifest` command of `vcpkg`.

```shell
vcpkg format-manifest <port>
# vcpkg format-manifest ports/librocket/vcpkg.json
```

This is a common error message and `vcpkg` should always warn you about doing
this anytime the manifest file fails validation, such as when you are updating
the port version.

### versioning

```shell
vcpkg --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions x-add-version --all --verbose
```

#### port-version

A version suffix distinguishing revisions to the packaging files. An integer.
Defaults to `0`.

The `port-version` should be incremented whenever a new version of the port
is published that does not change the upstream source version. When the
upstream source version is changed, the [version field][901] should change and
the `port-version` should be reset to `0` (or removed).

See [versioning][900] for more details.

### adding registry

Add the following to your `vcpkg-configuration.json`

```shell
{
  "$schema": "https://raw.githubusercontent.com/microsoft/vcpkg-tool/main/docs/vcpkg-configuration.schema.json",
  "default-registry": {
    "kind": "git",
    "repository": "https://github.com/Microsoft/vcpkg",
    "baseline": "xxx"
  },
  "registries": [
    {
      "kind": "git",
      "repository": "https://github.com/i8degrees/vcpkg-ports",
      "baseline": "e9c2cd727241dddac5bd568a6f82ae0f7692597f",
      "packages": [ "librocket" ]
    }
  ]
}
```

## related

- https://github.com/libRocket/libRocket.git (upstream)
- https://github.com/i8degrees/nomlib.git (library)
- https://github.com/i8degrees/ttcards.git (game)

[0]: https://github.com/microsoft/vcpkg
[100]: https://vcpkg.io/en/packages
[901]: https://learn.microsoft.com/en-us/vcpkg/reference/vcpkg-json#version
[900]: https://learn.microsoft.com/en-us/vcpkg/users/versioning#version-schemes
