-- Performing post-build validation
/home/jeff/Projects/vcpkg-ports.git/ports/nomlib/portfile.cmake: warning: This port installs the following CMake files in places CMake files are not expected. CMake files should be installed in ${CURRENT_PACKAGES_DIR}/share/${PORT}. To suppress this message, add set(VCPKG_POLICY_SKIP_MISPLACED_CMAKE_FILES_CHECK enabled)
/home/jeff/.local/share/vcpkg/packages/nomlib_x64-linux-dynamic: note: the files are relative to ${CURRENT_PACKAGES_DIR} here

note: lib/cmake/nomlib/nomlibConfig.cmake
note: lib/cmake/nomlib/nomlib-shared-targets.cmake
note: lib/cmake/nomlib/nomlibConfigVersion.cmake
note: lib/cmake/nomlib/nomlib-shared-targets-release.cmake
note: debug/lib/cmake/nomlib/nomlibConfig.cmake
note: debug/lib/cmake/nomlib/nomlib-shared-targets.cmake
note: debug/lib/cmake/nomlib/nomlibConfigVersion.cmake
note: debug/lib/cmake/nomlib/nomlib-shared-targets-debug.cmake
/home/jeff/Projects/vcpkg-ports.git/ports/nomlib/portfile.cmake: warning: This port creates ${CURRENT_PACKAGES_DIR}/lib/cmake and/or ${CURRENT_PACKAGES_DIR}/debug/lib/cmake, which should be merged and moved to ${CURRENT_PACKAGES_DIR}/share/${PORT}/cmake. Please use the helper function vcpkg_cmake_config_fixup() from the port vcpkg-cmake-config. To suppress this message, add set(VCPKG_POLICY_SKIP_LIB_CMAKE_MERGE_CHECK enabled)
/home/jeff/Projects/vcpkg-ports.git/ports/nomlib/portfile.cmake: warning: There should be no absolute paths, such as the following, in an installed package. To suppress this message, add set(VCPKG_POLICY_SKIP_ABSOLUTE_PATHS_CHECK enabled)
note: /home/jeff/.local/share/vcpkg/packages
note: /home/jeff/.local/share/vcpkg/installed
note: /home/jeff/.local/share/vcpkg/buildtrees
note: /home/jeff/.local/share/vcpkg/downloads
/home/jeff/Projects/vcpkg-ports.git/ports/nomlib/portfile.cmake: note: Adding a call to `vcpkg_fixup_pkgconfig()` may fix absolute paths in .pc files
/home/jeff/.local/share/vcpkg/packages/nomlib_x64-linux-dynamic/debug/lib/pkgconfig/nomlib.pc: note: absolute paths found here
/home/jeff/.local/share/vcpkg/packages/nomlib_x64-linux-dynamic/lib/pkgconfig/nomlib.pc: note: absolute paths found here
/home/jeff/Projects/vcpkg-ports.git/ports/nomlib/portfile.cmake: warning: Found 3 post-build check problem(s). These are usually caused by bugs in portfile.cmake or the upstream build system. Please correct these before submitting this port to the curated registry.

Starting submission of nomlib:x64-linux-dynamic@0.13.1 to 1 binary cache(s) in the background
Elapsed time to handle nomlib:x64-linux-dynamic: 2.3 min
Total install time: 15 min
Installed contents are licensed to you by owners. Microsoft is not responsible for, nor does it grant any licenses to, third-party packages.
Some packages did not declare an SPDX license. Check the `copyright` file for each package for more information about their licensing.
Packages installed in this vcpkg installation declare the following licenses:

(AFL-2.1 OR GPL-2.0-or-later)
(BSD-3-Clause OR GPL-2.0-only)
(FTL OR GPL-2.0-or-later)
(LGPL-2.1-only OR MPL-1.1)
BSD-2-Clause
BSD-3-Clause
LGPL-2.0-only
LGPL-2.0-or-later
LGPL-2.1-or-later
MIT
Zlib
bzip2-1.0.6
libpng-2.0
libtiff

Completed submission of sdl2-ttf:x64-linux-dynamic@2.24.0 to 1 binary cache(s) in 70.3 ms
Waiting for 1 remaining binary cache submissions...
Completed submission of nomlib:x64-linux-dynamic@0.13.1 to 1 binary cache(s) in 569 ms (1/1)
All requested installations completed successfully in: 15 min
