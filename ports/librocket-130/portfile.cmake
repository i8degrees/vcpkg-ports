# 	See additional helpful variables in /docs/maintainers/vcpkg_common_definitions.md

set(LIBROCKET_VERSION 1.3.0)
vcpkg_download_distfile(ARCHIVE
  URLS "https://github.com/i8degrees/libRocket/archive/refs/tags/${LIBROCKET_VERSION}.zip"
  SHA512 29853e60c00a8cc6a9e32e70c02c7bc479608bd6eabddc7d360dd6a732658d747751fed876886af3ecc669c92debc4c0fd4e46355f7947316b2a6a596f2c56ab
  FILENAME "librocket-${LIBROCKET_VERSION}.zip"
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH BASE_SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    REF 1.3.0
    # (Optional) Read the docs for how to generate patches at:
    # https://github.com/microsoft/vcpkg-docs/blob/main/vcpkg/examples/patching.md
    # PATCHES
    #   001_port_fixes.patch
    #   002_more_port_fixes.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
    python          BUILD_PYTHON_BINDINGS=OFF
)
set(PORT_DEBUG OFF)
vcpkg_cmake_configure(
  SOURCE_PATH "${BASE_SOURCE_PATH}/Build"
    OPTIONS
      ${FEATURE_OPTIONS}
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
vcpkg_cmake_config_fixup(
  #PACKAGE_NAME libRocket
  #CONFIG_PATH lib/librocket/cmake
)

file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/debug/lib/libRocket/cmake")

# Windows Debug metadata, symbols etc
vcpkg_copy_pdbs()

#file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

#file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/libRocket" "${CURRENT_PACKAGES_DIR}/lib/libRocket")

#file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
#file(INSTALL "${CURRENT_PACKAGES_DIR}/libRocketConfig.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

vcpkg_install_copyright(FILE_LIST "${BASE_SOURCE_PATH}/readme.md")

# install usage text for importing library into cmake build
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

