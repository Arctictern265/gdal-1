# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru
# ******************************************************************************
# * Copyright (C) 2013 Bishop
# * Copyright (C) 2017 Hiroshi Miura
## *
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

cmake_minimum_required (VERSION 2.8.12)

set(LIB_NAME "ogrsf_shp")
project ("lib${LIB_NAME}")

include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr)  
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts)  
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/generic)

set(LIB_HHEADERS
    ogrshape.h
	shapefil.h
)

set(LIB_CSOURCES
	dbfopen.c	
	shpopen.c	
	shptree.c	
	shp_vsi.c	
	ogrshapedatasource.cpp	
	ogrshapedriver.cpp	
	ogrshapelayer.cpp	
	shape2ogr.cpp		
	sbnsearch.c
)

include(MacroOptionalAddDriver)
MACRO_OPTIONAL_ADD_DRIVER(SHP "ESRI shape-file" ON)
if(OGR_ENABLE_SHP)
    add_definitions(-DDSHAPELIB_DLLEXPORT -DSAOffset=vsi_l_offset)

    if(GDAL_USE_CPL)
        add_definitions(-DUSE_CPL)
    endif(GDAL_USE_CPL)

    set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
    add_library(${LIB_NAME} OBJECT ${LIB_HHEADERS} ${LIB_CSOURCES})
endif()
