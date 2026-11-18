# 	See additional helpful variables in /docs/maintainers/vcpkg_common_definitions.md

set(NOM_VERSION 0.13.1)
set(NOM_TAG "dev")
vcpkg_download_distfile(ARCHIVE
  URLS "https://github.com/i8degrees/nomlib/archive/refs/heads/${NOM_TAG}.zip"
  SHA512 "d490f7b3ccb26d7506816b662b3a8e1e6361a268b411d75cf13b40411d7eae8a637e7c40cff97251dc270bf35136f511ee188a29b0f3068d4fce262aa4cd481a"
  FILENAME "nomlib_${NOM_VERSION}.zip"
)

vcpkg_extract_source_archive_ex(
  OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    REF 0.13.1
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
      "-DDEBUG_ASSERT=ON"
      "-DNOM_BUILD_AUDIO_UNIT=OFF"
      "-DHIDE_SYMBOL_VISIBILITY=OFF"
      "-DNOM_INSTALL_GCDB=OFF"
)

vcpkg_cmake_install()
#vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/nomlib PACKAGE_NAME nomlib)
#vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")

# install usage text for importing library into cmake build
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

