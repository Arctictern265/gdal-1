# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author:   Hiroshi Miura <miurahr@linux.com>
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

set(LIB_NAME "ogrsf_cad_libopencad")
project ("lib${LIB_NAME}")

include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/cad)

set(LIB_HHEADERS
        opencad.h
        opencad_api.h
        cadclasses.h
        cadcolors.h
        caddictionary.h
        cadfile.h
        cadfileio.h
        cadlayer.h
        cadobjects.h
        cadtables.h
)

set(LIB_CSOURCES
        cadclasses.cpp
        cadcolors.cpp
        caddictionary.cpp
        cadfile.cpp
        cadfileio.cpp
        cadgeometry.cpp
        cadfilestreamio.cpp
        cadheader.cpp
        cadlayer.cpp
        cadobjects.cpp
        cadtables.cpp
        opencad.cpp
)

add_subdirectory(dwg)
set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
add_library(${LIB_NAME} OBJECT ${LIB_HHEADERS} ${LIB_CSOURCES})
set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} PARENT_SCOPE)
