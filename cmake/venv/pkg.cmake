# vim: ft=cmake

if ("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
	message (FATAL_ERROR 
		"Do **NOT** build projects in source directory!\n")
endif()

if (NOT DEFINED ENV{VIRTUAL_ENV})
	message (FATAL_ERROR 
		"Not found environment variable VIRTUAL_ENV, you should activate venv before\n")
endif ()

if (NOT DEFINED CMAKE_INSTALL_PREFIX)
	message (FATAL_ERROR 
		"Not found variable CMAKE_INSTALL_PREFIX, you should use activate venv before\n")
endif ()

if (NOT TARGET uninstall)
	add_custom_target (uninstall 
		xargs rm -fv < ${CMAKE_BINARY_DIR}/install_manifest.txt)
endif ()

set (CMAKE_VERBOSE_MAKEFILE   off)
set (CMAKE_COLOR_MAKEFILE     on)
set (CMAKE_USE_RELATIVE_PATHS on)

set (CMAKE_C_FLAGS_RELEASE          "-g -O2 -pipe -Wall -Wextra")
set (CMAKE_CXX_FLAGS_RELEASE        "-g -O2 -pipe -Wall -Wextra")
set (CMAKE_EXE_LINKER_FLAGS_RELEASE "-g -O2 -pipe -Wall -Wextra")
set (CMAKE_C_FLAGS_DEBUG            "-ggdb3 -O0 -pg -pipe -Wall -Wextra")
set (CMAKE_CXX_FLAGS_DEBUG          "-ggdb3 -O0 -pg -pipe -Wall -Wextra")
set (CMAKE_EXE_LINKER_FLAGS_DEBUG   "-ggdb3 -O0 -pg -pipe -Wall -Wextra")

include_directories (BEFORE $ENV{VIRTUAL_ENV}/include)
link_directories ($ENV{VIRTUAL_ENV}/lib)

file (STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/PKGNAME"  PKG_NAME)
file (STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/VERSION"  PKG_VERSION)
file (STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/REQUIRES" PKG_REQUIRES)

execute_process (COMMAND uname -i
	OUTPUT_VARIABLE PKG_ARCH
	OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process (COMMAND uname -n
	OUTPUT_VARIABLE PKG_HOST
	OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process (COMMAND date +%Y%m%d
	OUTPUT_VARIABLE PKG_DATE
	OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process (COMMAND whoami
	OUTPUT_VARIABLE PKG_USER
	OUTPUT_STRIP_TRAILING_WHITESPACE)

if ("${CMAKE_BUILD_TYPE}" STREQUAL "")
	set (CMAKE_BUILD_TYPE Release)
elseif (NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Release")
	string (TOLOWER "-${CMAKE_BUILD_TYPE}" PKG_NAME_SUFFIX)
	set (PKG_NAME "${PKG_NAME}${PKG_NAME_SUFFIX}")
endif ()

set (CPACK_GENERATOR                 "RPM")
set (CPACK_RPM_PACKAGE_RELOCATABLE   on)
set (CPACK_PACKAGE_VERSION           "${PKG_VERSION}")
set (CPACK_SYSTEM_NAME               "${PKG_ARCH}")
set (CPACK_RPM_PACKAGE_RELEASE       "${PKG_DATE}")
set (CPACK_RPM_PACKAGE_ARCHITECTURE  "${PKG_ARCH}")
set (CPACK_RPM_PACKAGE_VENDOR        "${PKG_USER}@${PKG_HOST}")
set (CPACK_RPM_PACKAGE_LICENSE       "License")
set (CPACK_RPM_PACKAGE_NAME          "${PKG_NAME}")
set (CPACK_RPM_PACKAGE_SUMMARY       "${PKG_NAME} library")
set (CPACK_RPM_PACKAGE_GROUP         "Development/Libraries")
set (CPACK_PACKAGING_INSTALL_PREFIX  "/pkg") 

message (STATUS "cmake variables:")
message (STATUS "... CMAKE_INSTALL_PREFIX .....: ${CMAKE_INSTALL_PREFIX}")
message (STATUS "... CMAKE_MODULE_PATH ........: ${CMAKE_MODULE_PATH}")

message (STATUS "venv/pkg variables:")
message (STATUS "... PKG_NAME .................: ${PKG_NAME}")
message (STATUS "... PKG_VERSION ..............: ${PKG_VERSION}")
message (STATUS "... PKG_REQUIRES .............: ${PKG_REQUIRES}")
message (STATUS "... PKG_ARCH .................: ${PKG_ARCH}")
message (STATUS "... PKG_HOST .................: ${PKG_HOST}")
message (STATUS "... PKG_DATE .................: ${PKG_DATE}")
message (STATUS "... PKG_USER .................: ${PKG_USER}")

# set CPACK_RPM_PACKAGE_LICENSE ...
# set CPACK_RPM_PACKAGE_REQUIRES ...
