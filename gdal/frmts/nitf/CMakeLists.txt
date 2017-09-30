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

set(LIB_NAME "frmts_nitf")
project ("lib${LIB_NAME}")

include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts)
include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/gtiff)
include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/vrt)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr)
include_directories(${GDAL_ROOT_SOURCE_DIR}/gcore)

set(LIB_HHEADERS
        mgrs.h
        nitflib.h
        nitfdataset.h
)

set(LIB_CSOURCES
        mgrs.c
        nitfdataset.cpp
        rpftocdataset.cpp
        nitfrasterband.cpp
        ecrgtocdataset.cpp
)

set(NITFLIB_CSOURCES
        nitffile.c
        nitfimage.c
        nitfaridpcm.cpp
        nitfbilevel.cpp
        rpftocfile.cpp
        nitfdes.c
        nitf_gcprpc.cpp
)

if(GDAL_USE_LIBTIFF_INTERNAL)
    include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/gtiff/libtiff)
    add_definitions(-DRENAME_INTERNAL_LIBTIFF_SYMBOLS)
endif()

if(GDAL_JPEG_SUPPORT)
    add_definitions(-DJPEG_SUPPORTED)
    if(GDAL_USE_LIBJPEG_INTERNAL)
        include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/jpeg/libjpeg)
    else()
        find_package(JPEG REQUIRED)
        set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${JPEG_LIBRARIES})
    endif()
    if(GDAL_JPEG12_SUPPORTED)
         add_definitions(-DJPEG_DUAL_MODE_8_12)
         set(LIB_CSOURCES ${LIB_CSOURCES}
            nitfwritejpeg_12.cpp
         )
    else()
         set(LIB_CSOURCES ${LIB_CSOURCES}
             nitfwritejpeg.cpp
         )
    endif()
endif()

add_definitions(-DFRMT_nitf)
set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
add_library(${LIB_NAME} OBJECT ${LIB_HHEADERS} ${NITFLIB_CSOURCES} ${LIB_CSOURCES})
set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} PARENT_SCOPE)
