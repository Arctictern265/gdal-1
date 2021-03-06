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

set(LIB_NAME "frmts_mrf")
project ("lib${LIB_NAME}")

include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr)
include_directories(${GDAL_ROOT_SOURCE_DIR}/gcore)

set(LIB_HHEADERS
        marfa.h
)

set(LIB_CSOURCES
        marfa_dataset.cpp
        mrf_band.cpp
        mrf_overview.cpp
        mrf_util.cpp

        JPEG_band.cpp
        JPNG_band.cpp
        PNG_band.cpp
        Raw_band.cpp
        Tif_band.cpp
)

set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB})

if(GDAL_JPEG12_SUPPORTED)
    set(LIB_CSOURCES ${LIB_CSOURCES} JPEG12_band.cpp)
    add_definitions(-DJPEG12_SUPPORTED)
endif()

if(GDAL_USE_LIBJPEG_INTERNNAL)
    include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/jpeg/libjpeg)
else()
    find_package(JPEG)
    if(JPEG_FOUND)
        include_directories(${JPEG_INCLUDE_DIR})
        set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${JPEG_LIBRARIES})
    endif()
endif()

if(GDAL_USE_LIBPNG_INTERNNAL)
    include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/png/libpng)
    add_definitions(-DINTERNAL_PNG)
else()
    find_package(PNG)
    if(PNG_FOUND)
        include_directories(${PNG_INCLUDE_DIR})
        set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${PNG_LIBRARIES})
    endif()
endif()

if(GDAL_USE_LIBZ_INTERNNAL)
    include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/zlib)
endif()

add_subdirectory(libLERC)
add_definitions(-DLERC)
include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/mrf/libLERC)
set(LIB_CSOURCES ${LIB_CSOURCES} LERC_band.cpp)

add_definitions(-DFRMT_mrf)
set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
add_library(${LIB_NAME} OBJECT ${LIB_HHEADERS} ${LIB_CSOURCES})
set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} PARENT_SCOPE)