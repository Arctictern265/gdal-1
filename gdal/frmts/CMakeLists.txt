# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru,
# *         Hiroshi Miura <miurahr@linux.com>
# ******************************************************************************
# * Copyright (C) 2012 Bishop
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

set(LIB_NAME "frmts")
project ("lib${LIB_NAME}")

include_directories(${GDAL_ROOT_SOURCE_DIR}/gcore)
include_directories(${GDAL_ROOT_SOURCE_DIR}/gdal)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts)

include_directories(${GDAL_ROOT_BINARY_DIR}/port)

# Builtin formats
add_subdirectory(png)
add_subdirectory(gxf)
add_subdirectory(gtiff)
add_subdirectory(hfa)
add_subdirectory(aigrid)
add_subdirectory(aaigrid)
add_subdirectory(ceos)
add_subdirectory(ceos2)
add_subdirectory(iso8211)
add_subdirectory(xpm)
add_subdirectory(sdts)
add_subdirectory(raw)
add_subdirectory(dted)
add_subdirectory(mem)
add_subdirectory(jdem)
add_subdirectory(envisat)
add_subdirectory(elas)
add_subdirectory(fit)
add_subdirectory(vrt)
add_subdirectory(usgsdem)
add_subdirectory(l1b)
add_subdirectory(nitf)
add_subdirectory(bmp)
add_subdirectory(airsar)
add_subdirectory(rs2)
add_subdirectory(ilwis)
add_subdirectory(rmf)
add_subdirectory(leveller)
add_subdirectory(sgi)
add_subdirectory(srtmhgt)
add_subdirectory(idrisi)
add_subdirectory(gsg)
add_subdirectory(ingr)
add_subdirectory(ers)
add_subdirectory(jaxapalsar)
add_subdirectory(dimap)
add_subdirectory(gff)
add_subdirectory(cosar)
add_subdirectory(pds)
add_subdirectory(adrg)
add_subdirectory(coasp)
add_subdirectory(tsx)
add_subdirectory(terragen)
add_subdirectory(blx)
add_subdirectory(msgn)
add_subdirectory(til)
add_subdirectory(r)
add_subdirectory(northwood)
add_subdirectory(saga)
add_subdirectory(xyz)
add_subdirectory(hf2)
add_subdirectory(kmlsuperoverlay)
add_subdirectory(ctg)
add_subdirectory(e00grid)
add_subdirectory(zmap)
add_subdirectory(ngsgeoid)
add_subdirectory(iris)
add_subdirectory(map)
add_subdirectory(cals)
add_subdirectory(safe)
add_subdirectory(sentinel2)
add_subdirectory(derived)
add_subdirectory(prf)
add_subdirectory(mrf)
add_subdirectory(webp)
add_subdirectory(wcs)
add_subdirectory(wms)
add_subdirectory(plmosaic)
add_subdirectory(wmts)
add_subdirectory(grib)
add_subdirectory(bsb)
add_subdirectory(openjpeg)
add_subdirectory(jpeg2000)
add_subdirectory(netcdf)
add_subdirectory(hdf5)
add_subdirectory(ogdi)
add_subdirectory(gif)
add_subdirectory(jpeg)
add_subdirectory(gta)
add_subdirectory(pcraster)
add_subdirectory(fits)
add_subdirectory(arg)

## FIXME: temporary disables incomplete hdf4 driver cmake recipe
#add_subdirectory(hdf4)

# OPTIONAL Formats
#
add_subdirectory(pcidsk)
# libz dependency
add_subdirectory(rik)
add_subdirectory(ozi)
add_subdirectory(pdf)
# sqlite dependency
add_subdirectory(rasterlite)
add_subdirectory(mbtiles)
# optional drivers
add_subdirectory(postgisraster)
add_subdirectory(jpegls)
add_subdirectory(bpg)
add_subdirectory(dods)
add_subdirectory(dds)
add_subdirectory(kea)
add_subdirectory(grass)
add_subdirectory(zlib)

# driver with proprietary libraries
add_subdirectory(jp2kak)
add_subdirectory(jpipkak)
add_subdirectory(jp2lura)


set(LIB_CSOURCES
    gdalallregister.cpp
)

set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} PARENT_SCOPE)
add_library(${LIB_NAME} OBJECT ${LIB_CSOURCES})

