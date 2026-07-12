# 	See additional helpful variables in /docs/maintainers/vcpkg_common_definitions.md

#set(NOM_VERSION 0.13.1)
set(NOM_VERSION 0.13.1)
set(NOM_TAG "feature/vcpkg")
vcpkg_download_distfile(ARCHIVE
  URLS https://github.com/i8degrees/nomlib/archive/refs/heads/${NOM_TAG}.zip
  SHA512 0
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
      "-DCMAKE_BUILD_TYPE=Release"
      "-DBUILD_EXAMPLES=ON"
      "-DDEBUG_ASSERT=ON"
      "-DCMAKE_C_COMPILER=/usr/bin/clang"
      "-DCMAKE_CXX_COMPILER=/usr/bin/clang++"
      "-DCMAKE_CXX_STANDARD=14"
      "-DCMAKE_CXX_STANDARD_REQUIRED=ON"
      #OPTIONS_RELEASE -DOPTIMIZE=2
)

vcpkg_cmake_install()
#vcpkg_cmake_config_fixup(CONFIG_PATH lib/libRocket/cmake PACKAGE_NAME libRocket)
vcpkg_copy_pdbs()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
#file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/libRocket" "${CURRENT_PACKAGES_DIR}/lib/libRocket")

#file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

vcpkg_install_copyright(FILE_LIST "${BASE_SOURCE_PATH}/README.md")

# install usage text for importing library into cmake build
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

