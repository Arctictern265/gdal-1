# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru, Hiroshi Miura
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

set(LIB_NAME "frmts_grib")
project ("lib${LIB_NAME}")

include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr)
include_directories(${GDAL_ROOT_SOURCE_DIR}/gcore)

set(LIB_HHEADERS
        gribdataset.h
)

set(LIB_CSOURCES
        gribdataset.cpp
)

include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/grib/degrib18/degrib)
include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/grib/degrib18/g2clib-1.0.4)

set(LIB_HHEADERS ${LIB_HHEADERS}
        degrib18/degrib/clock.h
        degrib18/degrib/datasource.h
        degrib18/degrib/filedatasource.h
        degrib18/degrib/memorydatasource.h
        degrib18/degrib/degrib1.h
        degrib18/degrib/degrib2.h
        degrib18/degrib/engribapi.h
        degrib18/degrib/fileendian.h
        degrib18/degrib/grib2api.h
        degrib18/degrib/inventory.h
        degrib18/degrib/scan.h
        degrib18/degrib/memendian.h
        degrib18/degrib/meta.h
        degrib18/degrib/metaname.h
        degrib18/degrib/myutil.h
        degrib18/degrib/myerror.h
        degrib18/degrib/tdlpack.h
        degrib18/degrib/type.h
        degrib18/degrib/weather.h
)

set(LIB_CSOURCES ${LIB_CSOURCES}
        degrib18/degrib/clock.c
        degrib18/degrib/filedatasource.cpp
        degrib18/degrib/memorydatasource.cpp
        degrib18/degrib/degrib1.cpp
        degrib18/degrib/degrib2.cpp
        degrib18/degrib/engribapi.c
        degrib18/degrib/fileendian.cpp
        degrib18/degrib/grib1tab.cpp
        degrib18/degrib/grib2api.c
        degrib18/degrib/inventory.cpp
        degrib18/degrib/myassert.c
        degrib18/degrib/scan.c
        degrib18/degrib/memendian.c
        degrib18/degrib/metaname.cpp
        degrib18/degrib/metaparse.cpp
        degrib18/degrib/metaprint.cpp
        degrib18/degrib/myutil.c
        degrib18/degrib/myerror.c
        degrib18/degrib/tdlpack.cpp
        degrib18/degrib/weather.c
)

set(LIB_HHEADERS ${LIB_HHEADERS}
        degrib18/g2clib-1.0.4/drstemplates.h
        degrib18/g2clib-1.0.4/grib2.h
        degrib18/g2clib-1.0.4/gridtemplates.h
        degrib18/g2clib-1.0.4/pdstemplates.h
)

set(LIB_CSOURCES ${LIB_CSOURCES}
        degrib18/g2clib-1.0.4/cmplxpack.c
        degrib18/g2clib-1.0.4/compack.c
        degrib18/g2clib-1.0.4/comunpack.c
        degrib18/g2clib-1.0.4/drstemplates.c
        degrib18/g2clib-1.0.4/g2_addfield.c
        degrib18/g2clib-1.0.4/g2_addgrid.c
        degrib18/g2clib-1.0.4/g2_addlocal.c
        degrib18/g2clib-1.0.4/g2_create.c
        degrib18/g2clib-1.0.4/g2_free.c
        degrib18/g2clib-1.0.4/g2_getfld.c
        degrib18/g2clib-1.0.4/g2_info.c
        degrib18/g2clib-1.0.4/g2_miss.c
        degrib18/g2clib-1.0.4/g2_unpack1.c
        degrib18/g2clib-1.0.4/g2_unpack2.c
        degrib18/g2clib-1.0.4/g2_unpack3.c
        degrib18/g2clib-1.0.4/g2_unpack4.c
        degrib18/g2clib-1.0.4/g2_unpack5.c
        degrib18/g2clib-1.0.4/g2_unpack6.c
        degrib18/g2clib-1.0.4/g2_unpack7.c
        degrib18/g2clib-1.0.4/gbits.c
        degrib18/g2clib-1.0.4/getdim.c
        degrib18/g2clib-1.0.4/getpoly.c
        degrib18/g2clib-1.0.4/g2_gribend.c
        degrib18/g2clib-1.0.4/gridtemplates.c
        degrib18/g2clib-1.0.4/int_power.c
        degrib18/g2clib-1.0.4/jpcpack.c
        degrib18/g2clib-1.0.4/jpcunpack.c
        degrib18/g2clib-1.0.4/misspack.c
        degrib18/g2clib-1.0.4/mkieee.c
        degrib18/g2clib-1.0.4/pack_gp.c
        degrib18/g2clib-1.0.4/pdstemplates.c
        degrib18/g2clib-1.0.4/rdieee.c
        degrib18/g2clib-1.0.4/reduce.c
        degrib18/g2clib-1.0.4/seekgb.c
        degrib18/g2clib-1.0.4/simpack.c
        degrib18/g2clib-1.0.4/simunpack.c
        degrib18/g2clib-1.0.4/specpack.c
        degrib18/g2clib-1.0.4/specunpack.c
        degrib18/g2clib-1.0.4/enc_jpeg2000.c
        degrib18/g2clib-1.0.4/dec_jpeg2000.cpp
)

if(GDAL_USE_LIBPNG_INTERNNAL)
    include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/png/libpng)
    add_definitions(-DUSE_PNG)
    set(LIB_CSOURCES ${LIB_CSOURCES}
            degrib18/g2clib-1.0.4/pngpack.c
            degrib18/g2clib-1.0.4/pngunpack.c
            degrib18/g2clib-1.0.4/enc_png.c
            degrib18/g2clib-1.0.4/dec_png.c
    )
    if(GDAL_USE_LIBZ_INTERNNAL)
        include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/zlib)
    endif()
else()
    find_package(PNG)
    if(PNG_FOUND)
        add_definitions(-DUSE_PNG)
        include_directories(${PNG_INCLUDE_DIR})
        set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${PNG_LIBRARIES})
        set(LIB_CSOURCES ${LIB_CSOURCES}
                degrib18/g2clib-1.0.4/pngpack.c
                degrib18/g2clib-1.0.4/pngunpack.c
                degrib18/g2clib-1.0.4/enc_png.c
                degrib18/g2clib-1.0.4/dec_png.c
        )
     endif()
endif()

add_definitions(-DFRMT_grib)
set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
add_library(${LIB_NAME} OBJECT ${LIB_HHEADERS} ${LIB_CSOURCES})