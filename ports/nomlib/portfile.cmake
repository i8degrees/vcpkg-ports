# 	See additional helpful variables in /docs/maintainers/vcpkg_common_definitions.md

#set(NOM_VERSION 0.13.1)
set(NOM_VERSION 0.13.1)
set(NOM_TAG "dev")
vcpkg_download_distfile(ARCHIVE
  URLS "https://github.com/i8degrees/nomlib/archive/refs/heads/${NOM_TAG}.zip"
  SHA512 "50c7857814255c2751a47ae82c3311b0709c23bc211ad84d2fb8dbe85adb7f5109685d464ce83d8268dc96cfe1580ec2e984ede8994d725ca41a7b60dab93826"
  FILENAME "nomlib_${NOM_VERSION}.zip"
)

vcpkg_extract_source_archive_ex(
  OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    REF 0.13.1
    #PATCHES
    #001_fixme.patch
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
      # FIXME(JEFF): This should never have to be touched
      # See also,
      # 1. https://learn.microsoft.com/en-us/vcpkg/troubleshoot/build-failures#fetchcontent-dependency-is-not-found-during-build-process
      "-DFETCHCONTENT_FULLY_DISCONNECTED=OFF"
      "-DBUILD_EXAMPLES=OFF"
      "-DBUILD_TESTS=OFF"
      "-DBUILD_DOCS=OFF"
      "-DDEBUG_ASSERT=ON"
      # TODO(JEFF): This needs to be relocated to the feature options -
      # (see above)
      "-DNOM_BUILD_AUDIO_UNIT=ON"
      # FIXME(JEFF): Workaround for lack of NOM_EXPORT macros for audio unit
      "-DHIDE_SYMBOL_VISIBILITY=OFF"
      "-DNOM_INSTALL_GCDB=OFF"
      # FIXME(JEFF): Hopefully this issue is solved by a recent add to
      # vendor/CMakeLists.txt -- `find_program(python3)`
      "-DPython3_EXECUTABLE:PATH=C:/Python312/python.exe"
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

