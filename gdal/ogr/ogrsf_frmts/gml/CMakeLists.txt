# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru
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

set(LIB_NAME "ogrsf_gml")
project ("lib${LIB_NAME}")

include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr)    
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts)    

# needed packages
find_package(EXPAT)
if(EXPAT_FOUND)
    include_directories(${EXPAT_INCLUDE_DIRS})
    add_definitions(-DHAVE_EXPAT)
	set(GDAL_HAVE_EXPAT ON CACHE INTERNAL "GDAL_HAVE_EXPAT")
endif()

find_package(XercesC)
if(XercesC_FOUND)
    include_directories(${XercesC_INCLUDE_DIRS})
    include_directories(/usr/include/xercesc)
    add_definitions(-DHAVE_XERCES)
    set(GDAL_HAVE_XERCES ON CACHE INTERNAL "GDAL_HAVE_XERCES")
endif()

find_package(Sqlite3)
if(SQLITE3_FOUND)
    include_directories(${SQLITE3_INCLUDE_DIR})
    add_definitions(-DHAVE_SQLITE)
    set(GDAL_HAVE_SQLITE ON CACHE INTERNAL "GDAL_HAVE_SQLITE")
endif()

set(LIB_HHEADERS
    gmlreader.h
    gmlreaderp.h
    gmlregistry.h
    gmlutils.h
    ogr_gml.h
    parsexsd.h
    xercesc_headers.h
)

set(LIB_CSOURCES
    gfstemplate.cpp
    gmlfeature.cpp
    gmlfeatureclass.cpp
    gmlhandler.cpp
    gmlpropertydefn.cpp
    gmlreader.cpp
    gmlreadstate.cpp
    gmlregistry.cpp
    gmlutils.cpp
    hugefileresolver.cpp
    ogrgmldatasource.cpp
    ogrgmldriver.cpp
    ogrgmllayer.cpp
    parsexsd.cpp
    resolvexlinks.cpp
)

include(MacroOptionalAddDriver)
MACRO_ADD_OGR_DEFAULT_DRIVER(GML gml ON)
if(OGR_ENABLE_GML)
    set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
    add_library(${LIB_NAME} OBJECT ${LIB_HHEADERS} ${LIB_CSOURCES})

    set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB})

    if(EXPAT_FOUND)
        set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${EXPAT_LIBRARIES})
    endif()

    if(XERCES_FOUND)
        set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${XercesC_LIBRARIES})
    endif()

    if(SQLITE3_FOUND)
        set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${SQLITE3_LIBRARY})
    endif()

    set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} PARENT_SCOPE)
endif()

