# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru,
# *         Hiroshi Miura <miurahr@linux.com>
# ******************************************************************************
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

project(gdal_autotest_cpp C CXX)

set(CMAKE_COLOR_MAKEFILE ON)

include_directories(
        "${CMAKE_SOURCE_DIR}/gdal/port"
        "${CMAKE_SOURCE_DIR}/gdal/alg"
        "${CMAKE_SOURCE_DIR}/gdal/gcore"
        "${CMAKE_SOURCE_DIR}/gdal/ogr"
        "${CMAKE_SOURCE_DIR}/gdal/ogr/ogrsf_frmts"
        "${CMAKE_SOURCE_DIR}/gdal/apps"
        "${CMAKE_SOURCE_DIR}/gdal/frmts/vrt"
)

include_directories(
        "${CMAKE_SOURCE_DIR}/autotest/cpp"
        "${CMAKE_SOURCE_DIR}/autotest/cpp/tut"
)

include_directories(
        "${CMAKE_BINARY_DIR}/gdal/gcore"
        "${CMAKE_BINARY_DIR}/gdal/port"
)

add_definitions(-DGDAL_COMPILATION)
set(GDAL_ROOT_BINARY_DIR "${CMAKE_BINARY_DIR}/gdal")

message(STATUS "---------------------------")
add_library(vsipreload ${CMAKE_SOURCE_DIR}/gdal/port/vsipreload.cpp)
enable_testing()
add_executable(gdal_unit_test
        gdal_unit_test.h
        gdal_unit_test.cpp
        test_alg.cpp
        test_cpl.cpp
        test_gdal.cpp
        test_gdal_aaigrid.cpp
        test_gdal_dted.cpp
        test_gdal_gtiff.cpp
        test_ogr.cpp
        test_ogr_geos.cpp
        test_ogr_shape.cpp
        test_osr.cpp
        test_osr_pci.cpp
        test_osr_ct.cpp
        test_osr_proj4.cpp
        test_triangulation.cpp
        tut/tut.hpp
        tut/tut_assert.hpp
        tut/tut_console_reporter.hpp
        tut/tut_exception.hpp
        tut/tut_gdal.h
        tut/tut_posix.hpp
        tut/tut_reporter.hpp
        tut/tut_restartable.hpp
        tut/tut_result.hpp
        tut/tut_runner.hpp
        tut/tut_gdal.cpp
        )
target_link_libraries(gdal_unit_test ${GDAL_LIB_NAME})
add_test(NAME gdal_unit_test
        COMMAND gdal_unit_test)
message(STATUS "test target: gdal_unit_test")

include(GdalTestUtils)
gdal_autotest_target(testcopywords test-copy-words cpp "")
gdal_autotest_target(testclosedondestroydm test-closed-on-destroy-DM cpp "")
gdal_autotest_target(testthreadcond test-threaded-condition cpp "")
gdal_autotest_target(testvirtualmem test-virtual-memory cpp "")
gdal_autotest_target(testblockcachewrite test-block-cache-write cpp "--debug ON")
gdal_autotest_target(testblockcachelimits test-block-cache-limit cpp "--debug ON")
gdal_autotest_target(testmultithreadedwriting test-multi-threaded-writing cpp "")
gdal_autotest_target(testdestroy test-destroy cpp "")
gdal_autotest_target(test_include_from_c_file test-include-from-C-file c "")
gdal_autotest_target(test_c_include_from_cpp_file test-C-include-from-CPP-file cpp "")
gdal_autotest_target(testperfcopywords test-performance-copy-words cpp "")

add_executable(testblockcache testblockcache.cpp)
target_link_libraries(testblockcache ${GDAL_LIB_NAME})
message(STATUS "test target: Test block cache")

add_test(NAME block-cache-1
		COMMAND testblockcache -check -co TILED=YES --debug TEST,LOCK -loops 3 --config GDAL_RB_LOCK_DEBUG_CONTENTION YES)
add_test(NAME block-cache-2
		COMMAND testblockcache -check -co TILED=YES --debug TEST,LOCK -loops 3 --config GDAL_RB_LOCK_DEBUG_CONTENTION YES --config GDAL_RB_LOCK_TYPE SPIN)
add_test(NAME block-cache-3
		COMMAND testblockcache -check -co TILED=YES -migrate)
add_test(NAME block-cache-4
		COMMAND testblockcache -check -memdriver)
add_test(NAME block-cache-5
		COMMAND testblockcache --config GDAL_BAND_BLOCK_CACHE HASHSET -check -co TILED=YES --debug TEST,LOCK -loops 3 --config GDAL_RB_LOCK_DEBUG_CONTENTION YES)
add_test(NAME block-cache-6
		COMMAND testblockcache --config GDAL_BAND_BLOCK_CACHE HASHSET -check -co TILED=YES --debug TEST,LOCK -loops 3 --config GDAL_RB_LOCK_DEBUG_CONTENTION YES --config GDAL_RB_LOCK_TYPE SPIN)

add_executable(testsse1 testsse.cpp)
set_target_properties(testsse1 PROPERTIES CXX_FLAGS "${CMAKE_CXX_FLAGS} -mavx2")
add_executable(testsse2 testsse.cpp)
set_target_properties(testsse2 PROPERTIES CXX_FLAGS "${CMAKE_CXX_FLAGS} -DUSE_SSE2_EMULATION")
add_executable(testsse3 testsse.cpp)
add_test(testsse1 testsse1)
add_test(testsse2 testsse2)
add_test(testsse3 testsse3)
