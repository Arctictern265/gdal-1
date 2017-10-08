# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru, Hiroshi Miura
# ******************************************************************************
# * Copyright (C) 2012,2013 Bishop
# * Copyright (C) 2017 Hiroshi Miura
# *
# * Permission is hereby granted, free of charge, to any person obtaining a
# * copy of this software and associated documentation files (the "Software"),
# * to deal in the Software without restriction, including without limitation
# * the rights to use, copy, modify, merge, publish, distribute, sublicense,
# * and/or sell copies of the Software, and to permit persons to whom the
# * Software is furnished to do so, subject to the following conditions:
# *
# * The above copyright notice and this permission notice shall be included
# * in all copies or substantial portions of the Software.
# *
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# * DEALINGS IN THE SOFTWARE.
# ******************************************************************************

cmake_minimum_required (VERSION 3.8)

set(PROJECT_NAME "gdallib")
project(${PROJECT_NAME} C CXX)

set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Configs" FORCE)

set(CMAKE_COLOR_MAKEFILE ON)

# parse the version number from gdal_version.h and include in GDAL_MAJOR_VERSION and GDAL_MINOR_VERSION
file(READ ${CMAKE_CURRENT_SOURCE_DIR}/gcore/gdal_version.h GDAL_VERSION_H_CONTENTS)
string(REGEX MATCH "GDAL_VERSION_MAJOR[ \t]+([0-9]+)"
  GDAL_MAJOR_VERSION ${GDAL_VERSION_H_CONTENTS})
string (REGEX MATCH "([0-9]+)"
  GDAL_MAJOR_VERSION ${GDAL_MAJOR_VERSION})
string(REGEX MATCH "GDAL_VERSION_MINOR[ \t]+([0-9]+)"
  GDAL_MINOR_VERSION ${GDAL_VERSION_H_CONTENTS})
string (REGEX MATCH "([0-9]+)"
  GDAL_MINOR_VERSION ${GDAL_MINOR_VERSION})
string(REGEX MATCH "GDAL_VERSION_REV[ \t]+([0-9]+)"
  GDAL_REV_VERSION ${GDAL_VERSION_H_CONTENTS})
string (REGEX MATCH "([0-9]+)"
  GDAL_REV_VERSION ${GDAL_REV_VERSION})

# Setup package meta-data
set(GDAL_VERSION ${GDAL_MAJOR_VERSION}.${GDAL_MINOR_VERSION}.${GDAL_REV_VERSION})
message(STATUS "gdal version=[${GDAL_VERSION}]")

set(GDAL_LIB_NAME gdal${GDAL_MAJOR_VERSION}${GDAL_MINOR_VERSION})
message(STATUS "GDAL lib name ... " ${GDAL_LIB_NAME})

set(GDAL_LIB_NAME ${GDAL_LIB_NAME} PARENT_SCOPE)

#diagnosing info
message(STATUS "c++ compiler ... " ${CMAKE_CXX_COMPILER})

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

set(GDAL_ROOT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(GDAL_ROOT_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})

add_definitions(-DGDAL_COMPILATION)
set(CMAKE_CXX_STANDARD 11)

# set path to additional CMake modules
#set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

# uninstall target
configure_file(${CMAKE_MODULE_PATH}/cmake_uninstall.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake IMMEDIATE @ONLY)

# For windows, do not allow the compiler to use default target (Vista).
if(WIN32)
    add_definitions(-D_WIN32_WINNT=0x0501 -D_USRDLL)
endif()

if(MSVC)
    set(CMAKE_DEBUG_POSTFIX "d")
    add_definitions(-D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE)
    #add_definitions(-D_MBCS)
    set(GDAL_CSOURCES ${GDAL_CSOURCES} ${CMAKE_CURRENT_SOURCE_DIR}/gcore/Version.rc)
    source_group("Resource Files" FILES ${CMAKE_CURRENT_SOURCE_DIR}/gcore/Version.rc)
endif()

add_definitions(-DSTRICT -DHAVE_SSE_AT_COMPILE_TIME)

if(UNIX)
    add_definitions(-DCPL_LSB)
    add_definitions(-D_FORTIFY_SOURCE)
    set(CMAKE_POSITION_INDEPENDENT_CODE ON)
endif()

option(GDAL_USE_CPL "Set ON to use cpl" ON)

option(GDAL_ENABLE_OGR "Build OGR module" ON)
if(GDAL_ENABLE_OGR)
	add_definitions(-DOGR_ENABLED)
endif()

include_directories(${GDAL_ROOT_SOURCE_DIR}/port)
include_directories(${GDAL_ROOT_BINARY_DIR}/port)
include_directories(${GDAL_ROOT_BINARY_DIR}/gcore)

set(GDAL_TARGET_OBJECTS "")
set(GDAL_TARGET_LINK_LIB "")

add_subdirectory(port)
add_subdirectory(gcore)
add_subdirectory(alg)
if(GDAL_ENABLE_OGR)
    add_subdirectory(ogr)
endif()
add_subdirectory(frmts)
add_subdirectory(apps)
add_subdirectory(gnm)

add_subdirectory(swig)

message(STATUS "---------------------------")
list(REMOVE_DUPLICATES GDAL_TARGET_OBJECTS)
foreach(TO ${GDAL_TARGET_OBJECTS})
	message(STATUS "gdal link=${TO}")
endforeach()
message(STATUS "---------------------------")

option(GDAL_BUILD_SHARED "Set ON to build shared library" ON)
if(GDAL_BUILD_SHARED)
	add_library(${GDAL_LIB_NAME} SHARED ${GDAL_CSOURCES} ${GDAL_TARGET_OBJECTS})
else()
	add_library(${GDAL_LIB_NAME} STATIC ${GDAL_CSOURCES} ${GDAL_TARGET_OBJECTS})
endif()

configure_file(${CMAKE_MODULE_PATH}/gdal_def.cmake ${GDAL_ROOT_BINARY_DIR}/gcore/gdal_def.h @ONLY)

list(REMOVE_DUPLICATES GDAL_TARGET_LINK_LIB)
foreach(TL ${GDAL_TARGET_LINK_LIB})
	message(STATUS "gdal target link lib=${TL}")
endforeach()

if(GDAL_TARGET_LINK_LIB)
	target_link_libraries(${GDAL_LIB_NAME} ${GDAL_TARGET_LINK_LIB})
endif()

set_target_properties(${GDAL_LIB_NAME}
	PROPERTIES PROJECT_LABEL ${PROJECT_NAME}
    VERSION ${GDAL_VERSION}
    SOVERSION 1
	ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

if(MSVC)
    if(CMAKE_CL_64)
		set_target_properties(${GDAL_LIB_NAME} PROPERTIES STATIC_LIBRARY_FLAGS "/machine:x64")
		add_definitions(-D_WIN64)
    endif(CMAKE_CL_64)
endif()

if(WIN32)
    if(CMAKE_CL_64)
        install(TARGETS ${GDAL_LIB_NAME}
			RUNTIME DESTINATION bin
			ARCHIVE DESTINATION lib/x64
			LIBRARY DESTINATION lib/x64)
    else()
        install(TARGETS ${GDAL_LIB_NAME}
			RUNTIME DESTINATION bin
			ARCHIVE DESTINATION lib/x86
			LIBRARY DESTINATION lib/x86)
    endif()
else(WIN32)
    install(TARGETS ${GDAL_LIB_NAME}
        RUNTIME DESTINATION bin
        ARCHIVE DESTINATION lib/gdal
        LIBRARY DESTINATION lib/gdal)
endif()
install(FILES ${GDAL_ROOT_BINARY_DIR}/gcore/gdal_def.h DESTINATION include/gdal)
install(FILES ${GDAL_ROOT_BINARY_DIR}/port/cpl_config.h DESTINATION include/gdal)

add_custom_target(uninstall COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)


# Documentation rules
find_package(Doxygen)
IF(DOXYGEN_FOUND)
    set(GDAL_DOXYGEN_OUTPUT_DIRECTORY "${GDAL_ROOT_BINARY_DIR}/html")
    configure_file(${CMAKE_SOURCE_DIR}/cmake/Doxyfile.in ${GDAL_ROOT_BINARY_DIR}/Doxyfile)
    # Generate translated docs. Should go first, because index.html page should
    # be overwritten with the main one later
    add_custom_command(
        OUTPUT ${GDAL_ROOT_BINARY_DIR}/doc/html/header.html
        COMMAND ${DOXYGEN_EXECUTABLE} -w html html/header.html html/footer.html html/stylesheet.css ${GDAL_ROOT_BINARY_DIR}/Doxyfile
        MAIN_DEPENDENCY ${GDAL_ROOT_SOURCE_DIR}/Doxyfile /${GDAL_ROOT_SOURCE_DIR}/html/header.html
        WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}
	)
    # prepare language headers
    add_custom_command(
        OUTPUT ${GDAL_ROOT_BINARY_DIR}/html/header_ru.html
        COMMAND ${CMAKE_COMMAND}
        ARGS
        -Dinfile:FILEPATH=${GDAL_ROOT_SOURCE_DIR}/html/header.html
        -Doutfile:FILEPATH=${GDAL_ROOT_SOURCE_DIR}/html/header_ru.html
        -Dfrom:STRING="iso-8859-1"
        -Dto:STRING="utf-8"
        -P ${CMAKE_MODULE_PATH}/ReplaceStr.cmake
        MAIN_DEPENDENCY
            ${GDAL_ROOT_SOURCE_DIR}/html/header.html
        WORKING_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/html
    )
   # file(GENERATE
   #     OUTPUT %{GDAL_ROOT_BINARY_DIR}/html/header_br.html
   #     INPUT ${GDAL_ROOT_BINARY_DIR}/doc/html/header.html
   # )
    # run main doxygen
	add_custom_command(
        OUTPUT ${GDAL_ROOT_BINARY_DIR}/doc/html/index.html
        COMMAND ${DOXYGEN_EXECUTABLE} ${GDAL_ROOT_BINARY_DIR}/Doxyfile
        MAIN_DEPENDENCY ${GDAL_ROOT_BINARY_DIR}/Doxyfile
        WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}
    )
        set(DOC_IMAGES
                ${GDAL_ROOT_SOURCE_DIR}/doc/images/act-logo.png
                ${GDAL_ROOT_SOURCE_DIR}/doc/images/cadcorp_logo.jpg
                ${GDAL_ROOT_SOURCE_DIR}/doc/images/foss4g2013.png
                ${GDAL_ROOT_SOURCE_DIR}/doc/images/foss4g2014.png
                ${GDAL_ROOT_SOURCE_DIR}/doc/images/foss4g2017.png
                ${GDAL_ROOT_SOURCE_DIR}/doc/images/i3-logo.jpg
                ${GDAL_ROOT_SOURCE_DIR}/doc/images/ingres-logo.png
                ${GDAL_ROOT_SOURCE_DIR}/doc/images/OSGeo_project.png
                ${GDAL_ROOT_SOURCE_DIR}/doc/images/safe-logo.png
                ${GDAL_ROOT_SOURCE_DIR}/doc/images/src-logo.png
                ${GDAL_ROOT_SOURCE_DIR}/doc/images/waypoint_logo.png
                )
    file(COPY
            ${GDAL_ROOT_SOURCE_DIR}/data/gdalicon.png
            ${DOC_IMAGES}
            #${GDAL_ROOT_SOURCE_DIR}/doc/grid/*.png
            #${GDAL_ROOT_SOURCE_DIR}/frmts/*.html
            #${GDAL_ROOT_SOURCE_DIR}/frmts/*/frmt_*.html
            #${GDAL_ROOT_SOURCE_DIR}/frmts/openjpeg/*.xml
            #${GDAL_ROOT_SOURCE_DIR}/frmts/wms/frmt_*.xml
            #${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/*/frmt_*.html
            #${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/*/dev_*.html
            ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/ogr_formats.html
            ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/ogr_formats.html
            ${GDAL_ROOT_SOURCE_DIR}/ogr/ogr_feature_style.html
            #${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geopackage_aspatial.html
            #${GDAL_ROOT_SOURCE_DIR}/ogr/*.gif
            DESTINATION
            ${GDAL_ROOT_BINARY_DIR}/html
        )

ENDIF()