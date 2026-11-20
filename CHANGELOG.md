# Changelog

All notable changes to this custom vcpkg registry will be documented in this file.

## Unreleased

### Audit / Quality
- Audited both active ports (`librocket`, `nomlib`) and the `versions/` database.
  - Built both ports on `x64-linux`; inspected dependency trees and usage files.
  - Recorded findings in `observations.md` and a focused security review in `SECURITY_REVIEW.md`.
- Key findings:
  - `nomlib` pins a moving `dev` branch whose SHA512 has already drifted (fixed).
  - `nomlib` re-enables `FETCHCONTENT_FULLY_DISCONNECTED=OFF`, allowing build-time network fetches (fixed: deps pre-populated).
  - `librocket` forces `-DCMAKE_BUILD_TYPE=Debug` globally (partially fixed: now Windows-only workaround for a `ROCKET_ASSERT` linking issue).
  - `nomlib` `-DDEBUG_ASSERT=ON` forced run-time assertions into release artifacts (fixed: scoped to `OPTIONS_DEBUG`).
  - `nomlib` manifest contained inert `overrides`/`builtin-baseline` and redundant `version>=` constraints; now fully removed and documented in `templates/vcpkg.json.tmpl`.
  - `versions/l-/librocket.json` baseline points at `#0` while a newer `#1` entry exists (fixed: baseline now at `#3`).
- No credential leaks, secrets, or injection vectors were found in the port files.

### Port fixes — `nomlib`
- Fixed fresh-install failure caused by drifting `dev` branch SHA512.
- Pre-populated upstream FetchContent dependencies (`jsoncpp`, `tclap`, `rapidxml`) via `vcpkg_download_distfile` so the port builds with vcpkg's hermetic `FETCHCONTENT_FULLY_DISCONNECTED=ON` default.
- Added upstream patches to use FetchContent-provided source directories and to enable C language for CMake `check_c_source_compiles`.
- Removed hardcoded `C:/Python312/python.exe`; CMake's `FindPython3` resolves from PATH.
- Removed stale `001_fixme.patch` and `fixme.md`.
- Acknowledged `sdl2[wayland]` on Linux as an intentional choice to avoid the X11 feature dependency chain (dbus, ibus, etc.).
- Scoped `-DDEBUG_ASSERT=ON` to `OPTIONS_DEBUG` so release artifacts no longer include run-time assertions; debug artifacts still enable them.
- Re-enabled `NOM_BUILD_AUDIO_UNIT` so `libnomlib-audio` is produced.
- Added `-DNOM_USE_CCACHE=ON` to the configure options.
- Removed the portfile comment that recorded the obsolete rationale for keeping `builtin-baseline`/`overrides` in the port manifest.
- Enabled `vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/nomlib PACKAGE_NAME nomlib)` so `nomlibConfig.cmake` is installed under `share/nomlib`; removed broken `nomlib.pc` files.
- Dropped redundant `version>=` constraints from dependencies. All current upstream dependencies use the `version` (relaxed) scheme, so the minima were valid but far below baseline versions and never constrained resolution; removing them avoids unused metadata.
- Removed inert `builtin-baseline` and `overrides` from `ports/nomlib/vcpkg.json` and moved them to `templates/vcpkg.json.tmpl` so intended transitive-dependency versions are documented for consumer projects instead of being silently ignored by vcpkg.
- Aligned `librocket`, `libsndfile`, `sdl2-image`, and `sdl2-ttf` dependency `platform` expressions with `nomlib.supports` (`windows & x64` instead of the previous impossible `windows & x86 & static` gate).
- Bumped `nomlib` `port-version` to `3`.
- Refreshed `docs/dependency_tree.md` with current overlay-port dependency trees.
- Bumped `nomlib` upstream version to `0.14.0` (tagged release), replacing the moving `dev` branch pin. Updated source URL, SHA512, and reset `port-version` to `0`.
- Re-verified builds:
  - `nomlib:x64-linux@0.14.0#3` (static) — success; release `CMakeCache.txt` shows `DEBUG_ASSERT:BOOL=OFF` while debug shows `DEBUG_ASSERT:BOOL=ON`.
  - `nomlib:x64-linux-dynamic@0.14.0#3` (shared) — success; same release/debug `DEBUG_ASSERT` split confirmed.

### Port fixes — `librocket`
- Fixed `usage` file to reference the real exported CMake targets (`RocketCore`, `RocketControls`, `RocketDebugger`) instead of non-existent `*-static` aliases, and documented the `libRocket_INCLUDE_DIRS` variable.
- Repaired the `versions/` database by bumping `librocket` to port-version 2 so the baseline points at the current committed tree.
- Scoped the `-DCMAKE_BUILD_TYPE=Debug` override to Windows only, with a FIXME referencing the `ROCKET_ASSERT` macro linking issue. Linux/macOS now produce proper Release/Debug artifacts.
- Deleted the unused `vcpkg-cmake-wrapper.cmake`.
- Rebuilt and verified `librocket:x64-linux@1.3.0.0#3`; CMake consumer project links successfully and `lib/` contains `libRocketCore.a` instead of `libRocketCore_d.a`.
- Built `librocket:x64-linux-dynamic@1.3.0.0#3`; release `lib/` now contains `libRocketCore.so.1.3.0.0`, etc., with correct `_d` suffix retained in debug `lib/` only.

### Documentation
- `AGENTS.md`: reviewed and tightened port workflow guidance.
  - Updated `nomlib` port label to `v0.14.0`.
  - Fixed `vcpkg.json` `$schema` URL typo.
  - Replaced stale `vcpkg print-usage` checklist item with reading `share/<port>/usage` and a minimal consumer CMake build.
  - Clarified minimum-supported triplets as intended targets, not guaranteed validated targets.
  - Added convention against shipping unused helper files (e.g., `vcpkg-cmake-wrapper.cmake`) in port directories.
  - Restored/updated artifact persistence rules and included a complete CMake consumer example for usage verification.
- `SECURITY_REVIEW.md` (`.agent/reports/security/2026-11-16-ports.md`): added repository-level security review results (table format); updated after `nomlib` and `librocket` fixes.
- `observations.md` (`.agent/reports/observations.md`): added audit findings and build/usage verification notes (table format); updated after `nomlib`, `librocket`, and `AGENTS.md` changes.

### Templates
- Added `"$schema"` to `templates/vcpkg-configuration.json.tmpl` and `templates/vcpkg.json.tmpl` for validation and editor support.
- Fixed the doubled `.json` typo in `templates/vcpkg-configuration.json.tmpl` and `templates/vcpkg.json.tmpl` (`vcpkg.schema.json.json` → `vcpkg.schema.json`).
