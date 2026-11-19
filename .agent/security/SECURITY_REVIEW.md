# Security Review — vcpkg-ports `ports/`

**Scope:** `ports/librocket/` and `ports/nomlib/` in this registry.
**Date:** 2026-11-16

A detailed report lives in [`local://security-review.md`](local://security-review.md). This file summarizes the same findings for visibility at the repository root.

## Summary

| Port | Supply-chain posture | MainFinding |
|------|----------------------|-------------|
| `librocket` | Acceptable source pin (GitHub tag + SHA512) | Release triplets ship Debug artifacts due to a global `-DCMAKE_BUILD_TYPE=Debug` override; version DB was mutated in place. |
| `nomlib` | Acceptable | Source now pinned to immutable `v0.14.0` tag archive; vendor FetchContent deps pre-populated; CMake config fixup enabled and consumer-verified; hardcoded Windows Python path removed; audio unit re-enabled. `overrides`/`builtin-baseline` remain inert in port manifest. |

## Credentials / secrets / injection

No credential leaks, secrets, `execute_process` injections, or `eval`-like constructs were found in the inspected port files.

## Findings index

| # | Severity | Port | Finding | File/line |
|---|----------|------|---------|-----------|
| 1 | ✅ Fixed | nomlib | Moving `dev` branch pin replaced with v0.14.0 tag | `portfile.cmake:11-16` |
| 2 | ✅ Fixed | nomlib | Vendor FetchContent deps now pre-populated | `portfile.cmake` |
| 3 | ✅ Fixed | nomlib | Hardcoded Windows Python path removed | `portfile.cmake` |
| 4 | 🟢 Low | nomlib | `version>=` minima are low/redundant | `vcpkg.json:17,25,30,35,41,50,59,65` |
| 5 | 🟠 High | nomlib | `overrides`/`builtin-baseline` inert in port manifest | `vcpkg.json:12,76-93` |
| 6 | 🟠 High | librocket | Debug build forced for every triplet | `portfile.cmake:30-40` |
| 7 | ✅ Fixed | nomlib | CMake config fixup enabled | `portfile.cmake:90-98` |
| 8 | ✅ Fixed | nomlib | `usage` `nomlib-audio` is now built | `portfile.cmake`, `usage` |
| 9 | 🟡 Medium | nomlib | Platform expressions contradict `supports` | `vcpkg.json:11,16,24,58,64` |
| 10 | ✅ Fixed | librocket | Version DB repaired with port-version 2 | `versions/l-/librocket.json`, `baseline.json` |
| 11 | 🟡 Medium | librocket | `python` feature is a no-op | `vcpkg.json:23-29`, `portfile.cmake:19-28` |
| 12 | 🟡 Medium | librocket | `vcpkg-cmake-wrapper.cmake` is dead code | `vcpkg-cmake-wrapper.cmake`, `portfile.cmake:52` |
| 13 | ✅ Fixed | librocket | `usage` now lists correct targets and include dirs | `usage:5-14` |
| 14 | ✅ Fixed | nomlib | Dead `001_fixme.patch` removed | `ports/nomlib/` |
| 15 | ✅ Fixed | nomlib | `fixme.md` removed | `ports/nomlib/` |
| 16 | 🟢 Low | nomlib | Debug asserts forced into release artifacts | `portfile.cmake:37` |
| 17 | 🟢 Low | librocket | `freetype` gated to Windows only | `vcpkg.json:10-13` |
| 18 | 🟢 Low | nomlib | Linux `sdl2` omits X11 | `vcpkg.json:43-51` |
| 19 | 🟢 Low | both | Template `$schema` URL has doubled `.json` | `templates/*.tmpl` |

## Critical findings

| # | Finding | Evidence | Fix |
|---|---------|----------|-----|
| 1 | **nomlib pins a moving `dev` branch** *(fixed)* | Source URL now uses the immutable `v0.14.0` tag archive, and the SHA512 matches `076f99df…`. Fresh installs are reproducible again. | No further action. |
| 2 | **nomlib re-enables build-time FetchContent** *(fixed)* | Originally `-DFETCHCONTENT_FULLY_DISCONNECTED=OFF` defeated vcpkg's default `ON`. Now `jsoncpp`, `tclap`, `rapidxml` are pre-downloaded via `vcpkg_download_distfile` and `gamecontroller_db` remains disabled (`NOM_INSTALL_GCDB=OFF`). | Keep current pre-population; consider pinning `rapidxml`/`gamecontroller_db` to commits or replacing with vcpkg deps. |

## High findings

| # | Finding | Evidence | Fix |
|---|---------|----------|-----|
| 3 | **nomlib hardcodes `C:/Python312/python.exe`** *(fixed)* | Previously set a concrete Windows path. Now removed; CMake's `FindPython3` resolves from PATH. | No further action. |
| 4 | **nomlib `version>=` minima are low/redundant** | All current upstream dependencies (`librocket`, `libsndfile`, `openal-soft`, `sdl2`, `sdl2-image`, `sdl2-ttf`) use the `version` (relaxed) scheme, so the `version>=` strings parse and compare correctly. They are simply far below the versions shipped by modern baselines. They are not ignored (ports can declare transitive version constraints), but they are currently harmless. | Keep if documenting minimum supported versions; remove if you prefer to rely on the registry baseline. |
| 5 | **nomlib `overrides`/`builtin-baseline` are inert** | Per vcpkg docs, baselines and overrides only apply in top-level consumer manifests; they are ignored from ports consumed as dependencies. The installed `openal-soft` version (`1.25.1#2`) matched the active registry baseline, not the port's `overrides` entry (`1.25.1#1`). | Remove `builtin-baseline` and `overrides` from `ports/nomlib/vcpkg.json`; document intended versions in a consumer template if necessary. |
| 6 | **librocket forces Debug builds for every triplet** | `-DCMAKE_BUILD_TYPE=Debug` is appended after vcpkg's per-config value; CMake last-`-D`-wins → Release triplets install Debug artifacts (`libRocketCore_d.a`). | Remove the global override; patch the underlying `ROCKET_ASSERT` issue instead. |
| 7 | **nomlib disables CMake config fixup** *(fixed)* | `vcpkg_cmake_config_fixup` is now enabled; configs are installed under `share/nomlib`. Broken `nomlib.pc` files are removed because upstream's `Requires.private` lists vendored deps without `.pc` files. `find_package(nomlib CONFIG REQUIRED)` verified in both static and dynamic consumers. | No further action. |

## Medium findings

| # | Finding | Evidence | Fix |
|---|---------|----------|-----|
| 8 | **nomlib `usage` advertises `nomlib-audio`** *(fixed)* | `usage` lists `nomlib-audio`; `-DNOM_BUILD_AUDIO_UNIT=OFF` has been removed and `libnomlib-audio` is now built. | No further action. |
| 9 | **nomlib platform expressions contradict `supports`** | `supports` includes `windows & x64`, but required deps are gated to `windows & x86 & static`; `windows & x64` resolves then fails configure. | Align dependency platforms with `supports`; remove dead x86 clauses. |
| 10 | **librocket version DB mutated in place** *(fixed)* | `baseline.json` now points at `librocket` `1.3.0.0#2`, matching the current committed tree, and `x-add-version` was run without `--overwrite-version`. The stale `#1` entry remains historical. | No further action (or clean out stale `#1` if desired). |
| 11 | **librocket `python` feature is a no-op** | Feature depends on removed `python2`; `-DBUILD_PYTHON_BINDINGS=OFF` defeats `vcpkg_check_features`. | Remove the feature or fix the binding build. |
| 12 | **librocket wrapper is dead code** | `vcpkg-cmake-wrapper.cmake` is never installed and uses wrong names/paths. | Delete it. |
| 13 | **librocket `usage` is incomplete** *(fixed)* | Now references the real targets `RocketCore`, `RocketControls`, `RocketDebugger` and documents `${libRocket_INCLUDE_DIRS}`. A CMake consumer project with the new `usage` text links successfully. | No further action. |

## Low findings

| # | Finding | Evidence | Fix |
|---|---------|----------|-----|
| 14 | **nomlib patch committed but not applied** *(fixed)* | Dead `001_fixme.patch` has been deleted; `NOM_INSTALL_GCDB` logic is no longer needed. | No further action. |
| 15 | **nomlib `fixme.md` leaks local paths** *(fixed)* | `fixme.md` has been deleted. | No further action. |
| 16 | **nomlib debug asserts in release** | `-DDEBUG_ASSERT=ON` forces runtime aborts into release artifacts. | Scope to `OPTIONS_DEBUG` or remove. |
| 17 | **librocket `freetype` gated to Windows** | Upstream calls `find_package(Freetype REQUIRED)` unconditionally. | Declare `freetype` unconditionally. |
| 18 | **nomlib Linux `sdl2` drops X11** | `sdl2` uses only `wayland` on Linux (`features: ["wayland"]`, `default-features: false`). | Add `x11` or keep default features; document intent. |
| 19 | **Template `$schema` URL typo** | `vcpkg.schema.json.json` (doubled `.json`) in `templates/*.tmpl`. | Fix to `vcpkg.schema.json`. |

## Recommended fix order

1. Clean up nomlib manifest metadata (`overrides`, `builtin-baseline`, platform expressions).
2. Fix librocket Debug override (`-DCMAKE_BUILD_TYPE=Debug`).
3. Remove librocket dead code / broken feature (`vcpkg-cmake-wrapper.cmake`, `python` feature).
4. Fix template `$schema` typo.
