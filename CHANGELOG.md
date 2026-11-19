# Changelog

All notable changes to this custom vcpkg registry will be documented in this file.

## Unreleased

### Audit / Quality
- Audited both active ports (`librocket`, `nomlib`) and the `versions/` database.
  - Built both ports on `x64-linux`; inspected dependency trees and usage files.
  - Recorded findings in `observations.md` and a focused security review in `SECURITY_REVIEW.md`.
- Key findings:
  - `nomlib` pins a moving `dev` branch whose SHA512 has already drifted.
  - `nomlib` re-enables `FETCHCONTENT_FULLY_DISCONNECTED=OFF`, allowing build-time network fetches.
  - `librocket` forces `-DCMAKE_BUILD_TYPE=Debug`, causing Release triplets to ship Debug artifacts.
  - `nomlib` manifest contains inert `overrides`/`builtin-baseline` and scheme-incompatible `version>=` constraints.
  - `versions/l-/librocket.json` baseline points at `#0` while a newer `#1` entry exists.
- No credential leaks, secrets, or injection vectors were found in the port files.

### Port fixes — `nomlib`
- Fixed fresh-install failure caused by drifting `dev` branch SHA512.
- Pre-populated upstream FetchContent dependencies (`jsoncpp`, `tclap`, `rapidxml`) via `vcpkg_download_distfile` so the port builds with vcpkg's hermetic `FETCHCONTENT_FULLY_DISCONNECTED=ON` default.
- Added upstream patches to use FetchContent-provided source directories and to enable C language for CMake `check_c_source_compiles`.
- Removed hardcoded `C:/Python312/python.exe`; CMake's `FindPython3` resolves from PATH.
- Removed stale `001_fixme.patch` and `fixme.md`.
- Re-enabled `NOM_BUILD_AUDIO_UNIT` so `libnomlib-audio` is produced.
- Added `-DNOM_USE_CCACHE=ON` to the configure options.
- Added a note to `ports/nomlib/usage` documenting the incomplete/broken `nomlib.pc` and added `static`/`shared` component guidance.
- Enabled `vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/nomlib PACKAGE_NAME nomlib)` so `nomlibConfig.cmake` is installed under `share/nomlib`; removed broken `nomlib.pc` files.
- Dropped redundant `version>=` constraints from dependencies. All current upstream dependencies use the `version` (relaxed) scheme, so the minima were valid but far below baseline versions and never constrained resolution; removing them avoids unused metadata. `builtin-baseline` and `overrides` were kept in the port manifest as reference/consumer-test metadata (they are ignored when nomlib is consumed as a dependency). Recorded the rationale as a comment in `ports/nomlib/portfile.cmake` (vcpkg rejects comments and unknown fields in `vcpkg.json`).
- Refreshed `docs/dependency_tree.md` with current overlay-port dependency trees.
- Bumped `nomlib` upstream version to `0.14.0` (tagged release), replacing the moving `dev` branch pin. Updated source URL, SHA512, and reset `port-version` to `0`.
- Re-verified builds:
  - `x64-linux` (static) — success
  - `x64-linux-dynamic` (shared) — success

### Port fixes — `librocket`
- Fixed `usage` file to reference the real exported CMake targets (`RocketCore`, `RocketControls`, `RocketDebugger`) instead of non-existent `*-static` aliases, and documented the `libRocket_INCLUDE_DIRS` variable.
- Repaired the `versions/` database by bumping `librocket` to port-version 2 so the baseline points at the current committed tree.
- Rebuilt and verified `librocket:x64-linux@1.3.0.0#2`; CMake consumer project links successfully.

### Documentation
- `AGENTS.md`: reviewed and tightened port workflow guidance.
  - Added `vcpkg.json` `$schema` recommendation.
  - Clarified when a new port must be listed in `templates/vcpkg-configuration.json.tmpl`.
- `SECURITY_REVIEW.md`: added repository-level security review results (table format); updated after `nomlib` fixes.
- `observations.md`: added audit findings and build/usage verification notes (table format); updated after `nomlib` fixes.

### Templates
- Added `"$schema"` to `templates/vcpkg-configuration.json.tmpl` and `templates/vcpkg.json.tmpl` for validation and editor support.
- Note: both template files still have a typo — `vcpkg.schema.json.json` (doubled `.json`) — which should be fixed before use.
