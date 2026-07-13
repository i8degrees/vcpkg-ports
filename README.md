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

### development

```shell
vcpkg edit librocket --vcpkg-root .
```

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

### testing

```shell
# The directory path of the given overlay ports should be adjusted for your
# site
vcpkg remove <port> --x-overlay-ports=$HOME/Projects/vcpkg-ports.git/ports
vcpkg install <port> --x-overlay-ports=$HOME/Projects/vcpkg-ports.git/ports
```

### versioning

```shell
vcpkg --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions x-add-version --all --verbose
```

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
