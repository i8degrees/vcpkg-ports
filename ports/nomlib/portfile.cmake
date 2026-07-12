# 	See additional helpful variables in /docs/maintainers/vcpkg_common_definitions.md

#set(NOM_VERSION 0.13.1)
set(NOM_VERSION 0.13.1)
set(NOM_TAG "feature/vcpkg")
vcpkg_download_distfile(ARCHIVE
  URLS "https://github.com/i8degrees/nomlib/archive/refs/heads/${NOM_TAG}.zip"
  SHA512 "6efe1d223c3e9b1b69d3fb8c29300f5a68384004b556465a33907a39d42be2e348125ed0610e9f221403124709a799ef95cc897afb7d4da08f632f6476d4db4f"
  FILENAME "nomlib_${NOM_VERSION}.zip"
)

vcpkg_extract_source_archive_ex(
  OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    REF 0.13.1
    #PATCHES
    #"001_fixup-shared-library-macosx.patch"
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
      "-DFETCHCONTENT_FULLY_DISCONNECTED=OFF"
      "-DBUILD_EXAMPLES=OFF"
      "-DBUILD_TESTS=OFF"
      "-DBUILD_DOCS=OFF"
      "-DDEBUG_ASSERT=ON"
      "-DHIDE_SYMBOL_VISIBILITY=OFF"
      "-DCMAKE_C_COMPILER=/usr/bin/clang"
      "-DCMAKE_CXX_COMPILER=/usr/bin/clang++"
      "-DCMAKE_CXX_STANDARD=14"
      "-DCMAKE_CXX_STANDARD_REQUIRED=ON"
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")

# install usage text for importing library into cmake build
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

