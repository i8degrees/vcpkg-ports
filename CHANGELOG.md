# Changelog

All notable changes to this custom vcpkg registry will be documented in this file.

## Unreleased

### Documentation
- `AGENTS.md`: reviewed and tightened port workflow guidance.
  - Added `vcpkg.json` `$schema` recommendation.
  - Clarified when a new port must be listed in `templates/vcpkg-configuration.json.tmpl`.

### Templates
- Added `"$schema"` to `templates/vcpkg-configuration.json.tmpl` and `templates/vcpkg.json.tmpl` for validation and editor support.
