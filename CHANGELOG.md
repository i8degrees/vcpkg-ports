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

### Documentation
- `AGENTS.md`: reviewed and tightened port workflow guidance.
  - Added `vcpkg.json` `$schema` recommendation.
  - Clarified when a new port must be listed in `templates/vcpkg-configuration.json.tmpl`.
- `SECURITY_REVIEW.md`: added repository-level security review results (table format).
- `observations.md`: added audit findings and build/usage verification notes (table format).

### Templates
- Added `"$schema"` to `templates/vcpkg-configuration.json.tmpl` and `templates/vcpkg.json.tmpl` for validation and editor support.
- Note: both template files still have a typo — `vcpkg.schema.json.json` (doubled `.json`) — which should be fixed before use.
