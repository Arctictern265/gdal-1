# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru
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

set(LIB_NAME "frmts_jpeg2000")
project ("lib${LIB_NAME}")

include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr)
include_directories(${GDAL_ROOT_SOURCE_DIR}/gcore)

set(LIB_HHEADERS
        jpeg2000_vsil_io.h
)

set(LIB_CSOURCES
        jpeg2000_vsil_io.cpp
        jpeg2000dataset.cpp
)

find_package(Jasper)
if(JASPER_FOUND)
    # Detect GeoJP2 UUID hack
    include(CheckCSourceCompiles)
    set(CMAKE_REQUIRED_QUIET "yes")
    set(CMAKE_REQUIRED_LIBRARIES jasper)
    CHECK_C_SOURCE_COMPILES("#ifdef __cplusplus\nextern \"C\"\n#endif\n char jp2_encode_uuid ();int main () {return jp2_encode_uuid ();;return 0;}" HAVE_JASPER_UUID)
    if(HAVE_JASPER_UUID)
        message(STATUS "GeoJP2=${HAVE_JASPER_UUID}")
        add_definitions(-DHAVE_JASPER_UUID)
    endif()

    add_definitions(-DFRMT_jpeg2000)
    include_directories(${JASPER_INCLUDE_DIR})
    set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${JASPER_LIBRARIES})
    set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} PARENT_SCOPE)
    set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
    add_library(${LIB_NAME} OBJECT ${LIB_HHEADERS} ${LIB_CSOURCES})
endif()
