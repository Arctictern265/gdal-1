# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru, Hiroshi Miura
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

set(LIB_NAME "gcore")
project ("lib${LIB_NAME}")

if(GDAL_USE_CPL)
	add_definitions(-DUSE_CPL)
endif(GDAL_USE_CPL)

option(GDAL_PAM_ENABLED "Set ON to enable pam" ON)
if(GDAL_PAM_ENABLED)
	add_definitions(-DPAM_ENABLED)
endif(GDAL_PAM_ENABLED)

include_directories(${GDAL_ROOT_SOURCE_DIR}/alg)
include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/gtiff)
include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/vrt)
include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/mem)
include_directories(${GDAL_ROOT_SOURCE_DIR}/gcore)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr)
include_directories(${GDAL_ROOT_SOURCE_DIR}/gnm)
include_directories(${GDAL_ROOT_SOURCE_DIR}/gnm/gnm_frmts)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/generic)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson/libjson)

include_directories(${GDAL_ROOT_BINARY_DIR}/port)

set(LIB_HHEADERS
        gdal_version.h
        gdal.h
        gdaljp2metadata.h
        gdal_frmts.h
        gdal_pam.h
        gdal_priv.h
        gdal_proxy.h
        gdal_rat.h
        gdalexif.h
        gdalgeorefpamdataset.h
        gdal_priv_templates.hpp
        gdal_avx2_emulation.hpp
        gdal_def.h
        gdal_mdreader.h
        gdal_pam.h
        gdalsse_priv.h
)

set(LIB_CSOURCES
        gdalopeninfo.cpp
        gdaldrivermanager.cpp
        gdaldriver.cpp
        gdaldataset.cpp
        gdalrasterband.cpp
        gdal_misc.cpp
        rasterio.cpp
        gdalrasterblock.cpp
        gdalcolortable.cpp
        gdalmajorobject.cpp
        overview.cpp
        gdaldefaultoverviews.cpp
        gdalpamdataset.cpp
        gdalpamrasterband.cpp
        gdaljp2metadata.cpp
        gdaljp2box.cpp
        gdalmultidomainmetadata.cpp
        gdal_rat.cpp
        gdalgmlcoverage.cpp
        gdalpamproxydb.cpp
        gdalallvalidmaskband.cpp
        gdalnodatamaskband.cpp
        gdalnodatavaluesmaskband.cpp
        gdalproxydataset.cpp
        gdalproxypool.cpp
        gdaldefaultasync.cpp
        gdaldllmain.cpp
        gdalexif.cpp
        gdalclientserver.cpp
        gdalgeorefpamdataset.cpp
        gdaljp2abstractdataset.cpp
        gdalvirtualmem.cpp
        gdaloverviewdataset.cpp
        gdalrescaledalphaband.cpp
        gdaljp2structure.cpp
        gdal_mdreader.cpp
        gdaljp2metadatagenerator.cpp
        gdalabstractbandblockcache.cpp
        gdalarraybandblockcache.cpp
        gdalhashsetbandblockcache.cpp
        rasterio_ssse3.cpp
)

add_subdirectory(mdreader)

find_package(Sqlite3)
if(SQLITE3_FOUND)
    add_definitions(-DSQLITE_ENABLED)
    include_directories(${SQLITE3_INCLUDE_DIR})
    set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${SQLITE3_LIBRARIES})
endif()
find_package(LibXml2)
if(LibXml2_FOUND)
    include_directories(${LIBXML2_INCLUDE_DIR})
    add_definitions(-DHAVE_LIBXML2)
    set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${LIBXML2_LIBRARIES})
endif()

if(WIN32)
    set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} Ws2_32.lib PARENT_SCOPE)
else(WIN32)
    set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} PARENT_SCOPE)
endif(WIN32)

set(CXXFLAGS_NO_LTO_IF_SSSE3_NONDEFAULT "-DHAVE_AVX_AT_COMPILE_TIME -DHAVE_SSSE3_AT_COMPILE_TIME -DHAVE_SSE_AT_COMPILE_TIME -ftrapv  -Wall -Wextra -Winit-self -Wunused-parameter -Wformat -Werror=format-security -Wno-format-nonliteral -Wlogical-op -Wshadow -Werror=vla -Wmissing-declarations -Wnon-virtual-dtor -Woverloaded-virtual -fno-operator-names")
add_definitions(${CXXFLAGS_NO_LTO_IF_SSSE3_NONDEFAULT})
add_compile_options(-mssse3)

set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
add_library(${LIB_NAME} OBJECT ${LIB_HHEADERS} ${LIB_CSOURCES})

install(FILES ${LIB_HHEADERS} DESTINATION include/gdal)
