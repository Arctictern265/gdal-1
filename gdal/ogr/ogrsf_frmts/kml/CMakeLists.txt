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

set(LIB_NAME "ogrsf_kml")
project ("lib${LIB_NAME}")

include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr)  
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts)  

set(LIB_HHEADERS
	    ogr_kml.h
)

set(LIB_CSOURCES
        ogr2kmlgeometry.cpp
        ogrkmldatasource.cpp
        ogrkmldriver.cpp
        ogrkmllayer.cpp
)

include(MacroOptionalAddDriver)
MACRO_OPTIONAL_ADD_DRIVER(KML kml ON)
if(OGR_ENABLE_KML)
    if(EXPAT_FOUND)
        set(LIB_HHEADERS ${LIB_HHEADERS}
                kml.h
                kmlnode.h
                kmlutility.h
                kmlvector.h
        )

        set(LIB_CSOURCES ${LIB_CSOURCES}
                kml.cpp
                kmlnode.cpp
                kmlvector.cpp
        )
    endif()

    set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
    add_library(${LIB_NAME} OBJECT ${LIB_HHEADERS} ${LIB_CSOURCES})

    if(EXPAT_FOUND)
        set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${EXPAT_LIBRARIES} PARENT_SCOPE)
    endif()
endif()