# 	See additional helpful variables in /docs/maintainers/vcpkg_common_definitions.md
#
# Note on vcpkg.json metadata:
# - The dependency `version>=` constraints were removed because every current
#   upstream dependency uses the `version` (relaxed) scheme; the minima were
#   valid but far below baseline versions and never constrained resolution.
# - `builtin-baseline` and `overrides` are maintained in the consumer template
#   at `templates/vcpkg.json.tmpl`. They are not part of the port manifest
#   because vcpkg ignores them when `nomlib` is consumed as a dependency.
#
set(NOM_VERSION 0.14.0)
set(NOM_TAG "v0.14.0")
vcpkg_download_distfile(ARCHIVE
  URLS "https://github.com/i8degrees/nomlib/archive/refs/tags/${NOM_TAG}.zip"
  SHA512 "076f99df0cf60a41f9ab396f9a1b0961437f9a19a3d5eb781b082d57733292e2297d6b9fed0a36a5264bb6c649105659501e1b1d0ac1b9ea1b39206b2cc0dac4"
  FILENAME "nomlib_${NOM_VERSION}.zip"
)

vcpkg_extract_source_archive_ex(
  OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    REF 0.14.0
    PATCHES
      001_vcpkg_fixes.patch
)

# Pre-populate vendor dependencies so that upstream FetchContent can operate
# with vcpkg's hermetic FETCHCONTENT_FULLY_DISCONNECTED=ON default.
set(VENDOR_DIR "${CURRENT_BUILDTREES_DIR}/nomlib-vendor-deps")
file(MAKE_DIRECTORY "${VENDOR_DIR}")

# jsoncpp
vcpkg_download_distfile(JSONCPP_ARCHIVE
  URLS "https://github.com/open-source-parsers/jsoncpp/archive/refs/tags/0.7.0.zip"
  SHA512 "e99d00ac65620163679bbf5f14fff66657cc540f456e650dfb6780016a42869636f9b09dfcb819277901fff7844db6f75a024e3232b32229d487438981a0b0c8"
  FILENAME "nomlib-jsoncpp-0.7.0.zip"
)
vcpkg_extract_source_archive(
  JSONCPP_SOURCE
    ARCHIVE "${JSONCPP_ARCHIVE}"
    WORKING_DIRECTORY "${VENDOR_DIR}"
    PATCHES 003_jsoncpp_no-install.patch
)
vcpkg_find_acquire_program(PYTHON3)
vcpkg_execute_required_process(
  COMMAND "${PYTHON3}" "${JSONCPP_SOURCE}/amalgamate.py"
  WORKING_DIRECTORY "${JSONCPP_SOURCE}"
  LOGNAME "nomlib-jsoncpp-amalgamate"
)

# tclap
vcpkg_download_distfile(TCLAP_ARCHIVE
  URLS "https://github.com/mirror/tclap/archive/refs/tags/tclap-1-2-1-release-final.zip"
  SHA512 "9e771f4e4a0cd9426bc8754d77a26a2c84de0c1ee09b58bb3e9066fba81f19bfa113e5060d31f05999dfc0c47146d501658c4a35531f9a135152dc5b4275224b"
  FILENAME "nomlib-tclap-1-2-1-release-final.zip"
)
vcpkg_extract_source_archive(
  TCLAP_SOURCE
    ARCHIVE "${TCLAP_ARCHIVE}"
    WORKING_DIRECTORY "${VENDOR_DIR}"
)

# rapidxml
vcpkg_download_distfile(RAPIDXML_ARCHIVE
  URLS "https://github.com/discord/rapidxml/archive/refs/heads/master.zip"
  SHA512 "7a80a85349176c8b7b1b393b7a1512950067c7e7fd9495ade451878e0ee0adfa2c30843a371f2a4ce9edaa9da6f17ca310cdb98462fb9ab93fd2ef413fdd9966"
  FILENAME "nomlib-rapidxml-master.zip"
)
vcpkg_extract_source_archive(
  RAPIDXML_SOURCE
    ARCHIVE "${RAPIDXML_ARCHIVE}"
    WORKING_DIRECTORY "${VENDOR_DIR}"
    PATCHES 004_rapidxml_bug16.patch
)

# FIXME: Feature selection is not yet supported
#vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
#    FEATURES
#    python          "BUILD_PYTHON_BINDINGS=ON"
#)

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
      #${FEATURE_OPTIONS}
      "-DFETCHCONTENT_SOURCE_DIR_JSONCPP=${JSONCPP_SOURCE}"
      "-DFETCHCONTENT_SOURCE_DIR_TCLAP=${TCLAP_SOURCE}"
      "-DFETCHCONTENT_SOURCE_DIR_RAPIDXML=${RAPIDXML_SOURCE}"
      "-DBUILD_EXAMPLES=OFF"
      "-DBUILD_TESTS=OFF"
      "-DBUILD_DOCS=OFF"
      "-DHIDE_SYMBOL_VISIBILITY=OFF"
      "-DNOM_INSTALL_GCDB=OFF"
      "-DNOM_USE_CCACHE=ON"
    OPTIONS_DEBUG
      "-DDEBUG_ASSERT=ON"
)

vcpkg_cmake_install()
# upstream nomlib.pc lists vendored deps (rapidxml, jsoncpp, ...) that have no
# pkg-config files of their own, so vcpkg_fixup_pkgconfig cannot validate it.
# Remove the broken .pc files; consumers should use the CMake import targets.
file(REMOVE_RECURSE
  "${CURRENT_PACKAGES_DIR}/lib/pkgconfig"
  "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig"
)
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/nomlib PACKAGE_NAME nomlib)
vcpkg_copy_pdbs()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")

# install usage text for importing library into cmake build
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

