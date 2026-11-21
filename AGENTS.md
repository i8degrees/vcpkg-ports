# AGENTS.md

This is a custom Git-based vcpkg registry
[i8degrees/vcpkg-ports Custom Registry][0] for ports that have not been
published upstream.

- ports
    - [librocket][1] - v1.3.0.0 (upstream)
    - [nomlib][2] - v0.14.0

[0]: https://github.com/i8degrees/vcpkg-ports
[1]: https://github.com/libRocket/libRocket.git
[2]: https://github.com/i8degrees/nomlib.git

## Repository Layout

- `ports/<port-name>/`: Port definitions (`vcpkg.json`, `portfile.cmake`, patches, and `usage` files). Active ports include `librocket` and `nomlib`.
- `versions/`: Auto-generated vcpkg version database (`baseline.json` and `<first-letter>-/<port-name>.json`). **Never edit files inside `versions/` manually.**
- `templates/`: Consumer project templates (`vcpkg.json.tmpl` and `vcpkg-configuration.json.tmpl`).
- `docs/`: Additional registry documentation.

## Mandatory Port Modification Workflow

Whenever creating, updating, or fixing a port in `ports/<port-name>/`, execute these steps in exact order:

1. **Edit Port Files**: Update `vcpkg.json` and `portfile.cmake` inside `ports/<port-name>/`.
    - Prefer adding `"$schema": "https://raw.githubusercontent.com/microsoft/vcpkg-tool/main/docs/vcpkg.schema.json"` to `vcpkg.json` (and consumer templates) for validation and editor support. Check that the URL does not end in `.json.json`.
2. **Manage Versioning Rules**:
   - If the upstream source version changes: update `version` (or `version-semver` / `version-date`) in `vcpkg.json` and remove `port-version` (or reset it to `0`).
   - If only packaging files (`portfile.cmake`, patches, dependencies) change: keep `version` unchanged and increment `port-version` by `1`.
3. **Format & Validate Manifest**: Run manifest formatting on the modified `vcpkg.json` before committing:
   ```bash
   vcpkg format-manifest ports/<port-name>/vcpkg.json
   ```
    - A successful manifest validation should be committed as part of the port change, not as a separate commit, to keep `x-add-version` tree SHAs
    consistent.
4. **Commit Port Changes First**: `x-add-version` reads the Git tree SHA of the committed port directory. Stage and commit `ports/<port-name>/` before updating `versions/`:
   ```bash
   git add ports/<port-name>
   git commit -m "<port-name>: <summary of change>"
   ```
5. **Update the Version Database**: Run from the repository root using explicit builtin flags:
   ```bash
   vcpkg --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions x-add-version --all --verbose
   ```
   *(If fixing an existing version entry in-place during development, append `--overwrite-version`.)*
   - `--overwrite-version` must not be used for final polished versions because it mutates the DB in place.
6. **Commit Version Metadata**: Stage and commit the updated `versions/` directory:
   ```bash
   git add versions
   git commit -m "versions: update <port-name>"
   ```

## Local Testing & Verification

Before finalizing port changes, verify installation and dependency resolution using `--x-overlay-ports` from the repository root:

- **Reinstall & Build Test**:
  ```bash
  vcpkg remove <port-name> --recurse --x-overlay-ports=./ports
  vcpkg install <port-name> --x-overlay-ports=./ports
  ```
  - possibly with `--editable` as well, i.e.:
  `vcpkg remove <port-name> --recurse --editable --x-overlay-ports=./ports`

  - always clear `buildtrees/` and `packages/` when the port hash does not
  change, but one or more patches of a port are modified -- otherwise,
  reinstall can be no-op.

- **CI / Pre-Submission Smoke Test Guidance**:
    - always build the triplet you intend to ship, i.e.:
    `vcpkg install <port-name> --x-overlay-ports=./ports --triplet=x64-linux`

- **Inspect Dependency Tree**:
  ```bash
  vcpkg depend-info <port-name> --format=tree --x-overlay-ports=./ports
  ```
- **Verify Usage Instructions**:
  - Read the generated usage file after installation and confirm the targets and variables match the exported CMake config:
    ```bash
    cat ~/.local/share/vcpkg/installed/<triplet>/share/<port-name>/usage
    ```
  - Verify in a minimal consumer CMake project. Example:
    ```cmake
    cmake_minimum_required(VERSION 3.25)
    project(<port-name>_consumer LANGUAGES CXX)
    find_package(<port-name> CONFIG REQUIRED)
    add_executable(main main.cpp)
    target_link_libraries(main PRIVATE <target1> <target2>)
    ```
    Build it with:
    ```bash
    cmake -S . -B build \
      -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake \
      -DVCPKG_TARGET_TRIPLET=<triplet> \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build build
    ```

- **Developer Tips**:
    ```bash
    vcpkg edit <port-name>  --vcpkg-root .
    ```
- **Minimum Supported Triplets**:

- Linux ports target `x64-linux` for statically linked binaries (`.a`)
and `x64-linux-dynamic` for dynamically linked binaries (`.so`).

- macOS ports target `x64-osx` for statically linked binaries (`.a`)
and `x64-osx-dynamic` for dynamically linked binaries (`.dylib`).

- Windows ports target `x64-windows` for statically linked binaries
(`.lib`) and `x64-windows-dynamic` for dynamically linked binaries (`.dll`)

These are the intended supported triplets; individual ports may not be regularly validated on every target.

- After a port in this repo is updated but before it is committed, update
  `docs/dependency_tree.md` to reflect the current dependency tree(s).

## Consumer Templates & New Ports

- When adding a brand-new port to `ports/`, add its name to `templates/vcpkg-configuration.json.tmpl` in the `"packages"` array if the registry is consumed as a vcpkg `registry` (i.e., via `vcpkg-configuration.json`). When consumed only as an overlay (`--x-overlay-ports`), registry packages do not need to be listed there, but listing them is harmless and keeps the template consistent for registry-style consumers.
- Do not hardcode local paths (such as `/home/jeff/...`) inside `portfile.cmake` or `vcpkg.json`.
- Keep `portfile.cmake` deterministic: always verify `SHA512` hashes for downloaded archives rather than bypassing hash checks.

## local installation of vcpkg

- This repository checks out the latest version of `vcpkg` via git submodule
at `vendor/vcpkg`. Even if you find another existing copy of `vcpkg`, i.e.: 
`VCPKG_ROOT`, you must disregard this and use the vendored version supplied
here.

- bootstrap of vcpkg goes like this -- from this project's repository root:


```bash
git submodule update --init
git submodule sync
vendor/vcpkg/bootstrap-vcpkg.sh
vendor/vcpkg/vcpkg version
```

## Conventions

-  `versions/` files are machine-generated and must never be hand-edited.
- patches should be minimized and upstreamed where possible, and kept next to
the port's `portfile.cmake` with deterministic names.
- Do not ship unused helper files in a port directory (e.g., `vcpkg-cmake-wrapper.cmake`
  that is never installed, or commented-out dead code in `portfile.cmake`). Remove them
  or make them functional before committing.

Whenever a subagent finishes or you complete a review pass, immediately write the output to disk using the `write` tool:

- **Scout findings & observations:** Save to `.agent/reports/scout/<YYYY-MM-DD>-<topic>.md`
- **Security reviews:** Save to `.agent/reports/security/<YYYY-MM-DD>-<scope>.md`
- **General architectural observations:** Append to `.agent/reports/observations.md`

## Before committing checklist

- format manifest
- SHA512 verified
- port installs with intended triplet
- verify `share/<port-name>/usage` content or a minimal consumer CMake build

