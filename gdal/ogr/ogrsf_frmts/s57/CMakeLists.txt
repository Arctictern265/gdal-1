# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru
# ******************************************************************************
# * Copyright (C) 2013 Bishop
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

set(LIB_NAME "ogrsf_s57")
project ("lib${LIB_NAME}")

include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr)  
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts)  
include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/iso8211)

option(OGR_ENABLE_S57_BUILTIN_CLASSES "Set ON to build s57 driver with builin classes" OFF)
if (OGR_ENABLE_${_name})
    add_definitions(-DS57_BUILTIN_CLASSES)
endif()

set(LIB_HHEADERS
    ogr_s57.h
    s57.h
    s57tables.h
)

set(LIB_CSOURCES    
    ogrs57driver.cpp
    ogrs57datasource.cpp
    ogrs57layer.cpp
	s57classregistrar.cpp
    s57reader.cpp 
    ddfrecordindex.cpp
	s57featuredefns.cpp
    s57filecollector.cpp 
    s57writer.cpp
)

set(UTIL_SOURCES
        s57dump.cpp
        )

include(MacroOptionalAddDriver)
MACRO_OPTIONAL_ADD_DRIVER(S57 s57 ON)
if(OGR_ENABLE_S57)
    set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
    add_library(${LIB_NAME} OBJECT ${LIB_HHEADERS} ${LIB_CSOURCES})
endif()
