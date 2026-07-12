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

*WIP*

### adding registry

Add the following to your `vcpkg-configuration.json`

```shell
{
  "$schema": "https://raw.githubusercontent.com/microsoft/vcpkg-tool/main/docs/vcpkg-configuration.schema.json",
  "default-registry": {
    "kind": "git",
    "repository": "https://github.com/Microsoft/vcpkg",
    "baseline": "84a143e4caf6b70db57f28d04c41df4a85c480fa"
  },
  "registries": [
    {
      "kind": "git",
      "repository": "https://github.com/i8degrees/vcpkg-ports",
      "baseline": "6bac9c7e72813e8d79d91dc53b13c0f8d22bd61f",
      "packages": [ "librocket" ]
    }
  ]
}
```

## related

- https://github.com/i8degrees/nomlib.git
- https://github.com/i8degrees/ttcards.git

