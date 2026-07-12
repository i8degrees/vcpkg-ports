# vcpkg ports

My private vcpkg registry for ports that have not been published [upstream][0].

    ports/librocket

[0]: https://github.com/microsoft/vcpkg

## usage

- see also
    - [vcpkg: publish to a git repository](https://learn.microsoft.com/en-us/vcpkg/produce/publish-to-a-git-registry)
    - [vcpkg concepts: registries](https://learn.microsoft.com/en-us/vcpkg/concepts/registries)

### development

```shell
vcpkg edit <port>
```

### testing

```shell
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

- https://github.com/i8degrees/nomlib.git
- https://github.com/i8degrees/ttcards.git

