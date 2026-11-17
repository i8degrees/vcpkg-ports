# Security Review — vcpkg-ports `ports/`

**Scope:** `ports/librocket/` and `ports/nomlib/` in this registry.
**Date:** 2026-11-16

A detailed report lives in [`local://security-review.md`](local://security-review.md). This file summarizes the same findings for visibility at the repository root.

## Summary

| Port | Supply-chain posture | MainFinding |
|------|----------------------|-------------|
| `librocket` | Acceptable source pin (GitHub tag + SHA512) | Release triplets ship Debug artifacts due to a global `-DCMAKE_BUILD_TYPE=Debug` override; version DB was mutated in place. |
| `nomlib` | **Poor** | Source is a moving `dev` branch whose SHA512 has already drifted; upstream FetchContent network fetches are re-enabled; CMake config fixup is disabled; hardcoded Windows Python path. |

## Credentials / secrets / injection

No credential leaks, secrets, `execute_process` injections, or `eval`-like constructs were found in the inspected port files.

## Findings index

| # | Severity | Port | Finding | File/line |
|---|----------|------|---------|-----------|
| 1 | 🔴 Critical | nomlib | Moving `dev` branch pin already drifted | `portfile.cmake:5-8` |
| 2 | 🔴 Critical | nomlib | FetchContent network fetches re-enabled | `portfile.cmake:30-33` |
| 3 | 🟠 High | nomlib | Hardcoded Windows Python path | `portfile.cmake:44-46` |
| 4 | 🟠 High | nomlib | `version>=` minima are scheme-incompatible | `vcpkg.json:17,25,30,35,41,50,59,65` |
| 5 | 🟠 High | nomlib | `overrides`/`builtin-baseline` inert in port manifest | `vcpkg.json:12,76-93` |
| 6 | 🟠 High | librocket | Debug build forced for every triplet | `portfile.cmake:30-40` |
| 7 | 🟠 High | nomlib | CMake config fixup disabled | `portfile.cmake:50-51` |
| 8 | 🟡 Medium | nomlib | `usage` advertises `nomlib-audio` (not built) | `usage:8`, `portfile.cmake:38-40` |
| 9 | 🟡 Medium | nomlib | Platform expressions contradict `supports` | `vcpkg.json:11,16,24,58,64` |
| 10 | 🟡 Medium | librocket | Version DB mutated in place | `versions/l-/librocket.json`, `baseline.json` |
| 11 | 🟡 Medium | librocket | `python` feature is a no-op | `vcpkg.json:23-29`, `portfile.cmake:19-28` |
| 12 | 🟡 Medium | librocket | `vcpkg-cmake-wrapper.cmake` is dead code | `vcpkg-cmake-wrapper.cmake`, `portfile.cmake:52` |
| 13 | 🟡 Medium | librocket | `usage` omits include dirs / wrong targets | `usage:4-10` |
| 14 | 🟢 Low | nomlib | Patch committed but not applied | `portfile.cmake:14-15`, `001_fixme.patch` |
| 15 | 🟢 Low | nomlib | Build log `fixme.md` leaks local paths | `fixme.md:2-25` |
| 16 | 🟢 Low | nomlib | Debug asserts forced into release artifacts | `portfile.cmake:37` |
| 17 | 🟢 Low | librocket | `freetype` gated to Windows only | `vcpkg.json:10-13` |
| 18 | 🟢 Low | nomlib | Linux `sdl2` omits X11 | `vcpkg.json:43-51` |
| 19 | 🟢 Low | both | Template `$schema` URL has doubled `.json` | `templates/*.tmpl` |

## Critical findings

| # | Finding | Evidence | Fix |
|---|---------|----------|-----|
| 1 | **nomlib pins a moving `dev` branch** | `refs/heads/dev.zip` is regenerated on every upstream push; current `dev` hashes to `d490f7b3…`, not the pinned `63d57e13…`. Fresh installs fail hash verification. | Pin a release tag or commit-id archive; update SHA512. |
| 2 | **nomlib re-enables build-time FetchContent** | `-DFETCHCONTENT_FULLY_DISCONNECTED=OFF` defeats vcpkg's default `ON`. Upstream downloads `jsoncpp`, `tclap`, `rapidxml`, and `gamecontroller_db` (from a `master` branch) during configure/build. | Delete the option; vendor deps or declare them as vcpkg dependencies. |

## High findings

| # | Finding | Evidence | Fix |
|---|---------|----------|-----|
| 3 | **nomlib hardcodes `C:/Python312/python.exe`** | `portfile.cmake:44-46` sets a concrete Windows path; breaks other machines and conflicts with the registry "no local paths" rule. | Remove the option or use `vcpkg_find_acquire_program(PYTHON3)`. |
| 4 | **nomlib `version>=` minima are scheme-incompatible** | Minima (`2.0.4`, `2.0.1`, `2.0.14`, `1.17.2`) are `version-string` only; modern baseline versions are `relaxed`, causing manifest-mode resolution failures. | Remove `version>=` or express minima in the same scheme. |
| 5 | **nomlib `overrides`/`builtin-baseline` are inert** | These fields only apply in top-level consumer manifests; they give false guarantees inside a port manifest. | Remove them and document validated versions elsewhere. |
| 6 | **librocket forces Debug builds for every triplet** | `-DCMAKE_BUILD_TYPE=Debug` is appended after vcpkg's per-config value; CMake last-`-D`-wins → Release triplets install Debug artifacts (`libRocketCore_d.a`). | Remove the global override; patch the underlying `ROCKET_ASSERT` issue instead. |
| 7 | **nomlib disables CMake config fixup** | `vcpkg_cmake_config_fixup` and `vcpkg_fixup_pkgconfig` are commented out; configs live in `lib/cmake` (not searched by vcpkg) and `.pc` files contain absolute paths. | Enable both helpers; verify `find_package(nomlib CONFIG REQUIRED)` in a consumer. |

## Medium findings

| # | Finding | Evidence | Fix |
|---|---------|----------|-----|
| 8 | **nomlib `usage` advertises `nomlib-audio`** | `usage:8` lists `nomlib-audio`; portfile sets `-DNOM_BUILD_AUDIO_UNIT=OFF`. | Remove `nomlib-audio` from usage or expose audio as a feature. |
| 9 | **nomlib platform expressions contradict `supports`** | `supports` includes `windows & x64`, but required deps are gated to `windows & x86 & static`; `windows & x64` resolves then fails configure. | Align dependency platforms with `supports`; remove dead x86 clauses. |
| 10 | **librocket version DB mutated in place** | `versions/l-/librocket.json` has `#0` and `#1` entries with rewritten trees; `baseline.json` still points at `#0`. | Stop using `--overwrite-version`; re-add historical trees or bump `port-version`. |
| 11 | **librocket `python` feature is a no-op** | Feature depends on removed `python2`; `-DBUILD_PYTHON_BINDINGS=OFF` defeats `vcpkg_check_features`. | Remove the feature or fix the binding build. |
| 12 | **librocket wrapper is dead code** | `vcpkg-cmake-wrapper.cmake` is never installed and uses wrong names/paths. | Delete it. |
| 13 | **librocket `usage` is incomplete** | References non-existent `*-static` targets and omits required `${libRocket_INCLUDE_DIRS}`. | Simplify targets and document the include variable. |

## Low findings

| # | Finding | Evidence | Fix |
|---|---------|----------|-----|
| 14 | **nomlib patch committed but not applied** | `001_fixme.patch` is commented out in `portfile.cmake:14-15`; option name mismatch (`NOM_INSTALL_GCDB` vs `nomlib_INSTALL_GCDB`). | Apply after pinning GCDB to a commit, or delete the patch. |
| 15 | **nomlib `fixme.md` leaks local paths** | Build log contains `/home/jeff/…` absolute paths. | Delete the file. |
| 16 | **nomlib debug asserts in release** | `-DDEBUG_ASSERT=ON` forces runtime aborts into release artifacts. | Scope to `OPTIONS_DEBUG` or remove. |
| 17 | **librocket `freetype` gated to Windows** | Upstream calls `find_package(Freetype REQUIRED)` unconditionally. | Declare `freetype` unconditionally. |
| 18 | **nomlib Linux `sdl2` drops X11** | `sdl2` uses only `wayland` on Linux (`features: ["wayland"]`, `default-features: false`). | Add `x11` or keep default features; document intent. |
| 19 | **Template `$schema` URL typo** | `vcpkg.schema.json.json` (doubled `.json`) in `templates/*.tmpl`. | Fix to `vcpkg.schema.json`. |

## Recommended fix order

1. Pin nomlib to immutable content (tag/commit + SHA512).
2. Restore nomlib hermetic build (remove FetchContent disconnect override).
3. Clean up nomlib manifest metadata (`version>=`, `overrides`, `builtin-baseline`, platform expressions).
4. Fix nomlib consumption (config fixup, usage targets, Python path).
5. Fix librocket Debug override and registry version DB.
6. Remove dead code, committed logs, and template typos.
