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

set(LIB_NAME "ogrsf_sqlite")
project ("lib${LIB_NAME}")

include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts)  

set(LIB_HHEADERS
    ogr_sqlite.h
    ogrsqlite3ext.h
    ogrsqliteexecutesql.h
    ogrsqlitesqlfunctions.h
    ogrsqlitevirtualogr.h
    rasterlite2_header.h
    ogrsqliteutility.h
)

set(LIB_CSOURCES
	ogrsqlitedatasource.cpp
	ogrsqlitedriver.cpp
	ogrsqlitelayer.cpp
	ogrsqliteselectlayer.cpp
	ogrsqlitesinglefeaturelayer.cpp
	ogrsqlitetablelayer.cpp
	ogrsqlitevfs.cpp
	ogrsqliteviewlayer.cpp
    ogrsqliteexecutesql.cpp
    ## ogrsqliteregexp.cpp # should not compile directly. see comment in source.
    ## ogrsqlitesqlfunctions.cpp # should not compile directly. see comment in source.
    ogrsqlitevirtualogr.cpp
    rasterlite2.cpp
    ogrsqliteutility.cpp
    ogrsqliteapiroutines.c
)

include(MacroOptionalAddDriver)
MACRO_OPTIONAL_ADD_DRIVER(SQLITE SpatialLite ON)
if(OGR_ENABLE_SQLITE)
    find_package(Sqlite3 REQUIRED)
    if(SQLITE3_FOUND)
        include_directories(${SQLITE3_INCLUDE_DIR})
        add_definitions(-DHAVE_SQLITE)
        set(GDAL_HAVE_SQLITE ON CACHE INTERNAL "GDAL_HAVE_SQLITE")
    else(SQLITE3_FOUND)
        MESSAGE(FATAL_ERROR "Could not find Sqlite3")
    endif(SQLITE3_FOUND)

    set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
    add_library(${LIB_NAME} OBJECT ${LIB_HHEADERS} ${LIB_CSOURCES})

    if(SQLITE3_FOUND)
        set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${SQLITE3_LIBRARY})
    endif(SQLITE3_FOUND)
    set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} PARENT_SCOPE)
endif()
