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

cmake_minimum_required(VERSION 3.8)

set(LIB_NAME "ogrsf_frmts")
project("lib${LIB_NAME}")

include_directories(${GDAL_ROOT_SOURCE_DIR}/gcore)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts)

set(LIB_HHEADERS
        ogr_attrind.h
        ogrsf_frmts.h
    )

# expat
find_package(EXPAT)
if(EXPAT_FOUND)
    set(GDAL_HAVE_EXPAT ON CACHE INTERNAL "GDAL_HAVE_EXPAT")
endif()

# curl
find_package(CURL)
if(CURL_FOUND)
    set(GDAL_HAVE_CURL ON CACHE INTERNAL "GDAL_HAVE_CURL")
endif()

# always compiles in
add_subdirectory(generic)
add_definitions(-DTAB_ENABLED)
add_subdirectory(avc)
add_subdirectory(bna)
add_subdirectory(csv)
add_subdirectory(dgn)
add_subdirectory(geojson)
add_subdirectory(gml)
add_subdirectory(gmt)
add_subdirectory(mem)
add_subdirectory(kml)
add_subdirectory(mitab)
add_subdirectory(ntf)
add_subdirectory(gpx)
add_subdirectory(rec)
add_subdirectory(s57)
add_subdirectory(sdts)
add_subdirectory(shape)
add_subdirectory(tiger)
add_subdirectory(vrt)
add_subdirectory(geoconcept)
add_subdirectory(xplane)
add_subdirectory(georss)
add_subdirectory(gtm)
add_subdirectory(dxf)
add_subdirectory(pgdump)
add_subdirectory(gpsbabel)
add_subdirectory(sua)
add_subdirectory(openair)
add_subdirectory(pds)
add_subdirectory(htf)
add_subdirectory(aeronavfaa)
add_subdirectory(edigeo)
add_subdirectory(idrisi)
add_subdirectory(arcgen)
add_subdirectory(segukooa)
add_subdirectory(segy)
add_subdirectory(sxf)
add_subdirectory(openfilegdb)
add_subdirectory(wasp)
add_subdirectory(selafin)
add_subdirectory(jml)
add_subdirectory(vdv)


# depend curl
add_subdirectory(amigocloud)
add_subdirectory(gft)
add_subdirectory(cloudant)
add_subdirectory(couchdb)
add_subdirectory(csw)
add_subdirectory(wfs)
add_subdirectory(plscenes)
add_subdirectory(elastic)

# odbc
add_subdirectory(odbc)
add_subdirectory(pgeo)
add_subdirectory(mssqlspatial)
add_subdirectory(geomedia)
add_subdirectory(walk)

# xerces
add_subdirectory(ili)
add_subdirectory(gmlas)

# depend sqlite
add_subdirectory(nas)
add_subdirectory(osm)
add_subdirectory(pg)
add_subdirectory(sqlite)
add_subdirectory(xlsx)
add_subdirectory(vfk)


# optional drivers
add_subdirectory(dods)
#add_subdirectory(db2)
# add_subdirectory(arcobjects) #windows only
add_subdirectory(cad)
add_subdirectory(carto)
add_subdirectory(libkml)
add_subdirectory(mysql)
# add_subdirectory(mongodb)

set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
add_library(${LIB_NAME} OBJECT ${LIB_HHEADERS})
set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} PARENT_SCOPE)
