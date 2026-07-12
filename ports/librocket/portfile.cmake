# 	See additional helpful variables in /docs/maintainers/vcpkg_common_definitions.md

set(LIBROCKET_VERSION 1.3.0.0)
vcpkg_download_distfile(ARCHIVE
  URLS "https://github.com/libRocket/libRocket/archive/refs/tags/release-${LIBROCKET_VERSION}.zip"
  SHA512 "c1de584f97963de770fc81b46cb0d2c30a00b3276c2f83549b2be8eab22ad381df83e0ff8d14c6208d370e26fc19c552078514f0a76bec4dd834dabb2c89b3c1"
  FILENAME "librocket-${LIBROCKET_VERSION}.zip"
)

vcpkg_extract_source_archive_ex(
  OUT_SOURCE_PATH BASE_SOURCE_PATH
  ARCHIVE "${ARCHIVE}"
  REF 1.3.0.0
  PATCHES
    001_backport-cmake-config.patch
    002_remove-i386-osx-arch.patch
)

# FIXME: Feature selection is not yet supported
vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
  FEATURES
  python          "BUILD_PYTHON_BINDINGS=ON"
)

vcpkg_cmake_configure(
  SOURCE_PATH "${BASE_SOURCE_PATH}/Build"
    OPTIONS
      ${FEATURE_OPTIONS}
      "-DBUILD_PYTHON_BINDINGS=OFF"
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_C_COMPILER=/usr/bin/clang"
      "-DCMAKE_CXX_COMPILER=/usr/bin/clang++"
      "-DCMAKE_CXX_STANDARD=14"
      "-DCMAKE_CXX_STANDARD_REQUIRED=ON"
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
      "-DBUILD_SAMPLES=OFF"
      #OPTIONS_RELEASE -DOPTIMIZE=2
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/libRocket/cmake PACKAGE_NAME libRocket)
vcpkg_copy_pdbs()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/libRocket" "${CURRENT_PACKAGES_DIR}/lib/libRocket")

vcpkg_install_copyright(FILE_LIST "${BASE_SOURCE_PATH}/readme.md")

# install usage text for importing library into cmake build
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

