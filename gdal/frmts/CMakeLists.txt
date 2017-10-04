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

###############################################
include(GdalAddFrmts)
# Builtin formats
gdal_add_format(gxf)
gdal_add_format(gtiff)
gdal_add_format(hfa)
gdal_add_format(aaigrid)
gdal_add_format(ceos)
gdal_add_format(ceos2)
gdal_add_format(iso8211)
gdal_add_format(xpm)
gdal_add_format(sdts)
gdal_add_format(dted)
gdal_add_format(mem)
gdal_add_format(jdem)
gdal_add_format(envisat)
gdal_add_format(elas)
gdal_add_format(fit)
gdal_add_format(vrt)
gdal_add_format(l1b)
gdal_add_format(nitf)
gdal_add_format(rs2)
gdal_add_format(ilwis)
gdal_add_format(rmf)
gdal_add_format(leveller)
gdal_add_format(sgi)
gdal_add_format(srtmhgt)
gdal_add_format(idrisi)
gdal_add_format(gsg)
gdal_add_format(ingr)
gdal_add_format(ers)
gdal_add_format(jaxapalsar)
gdal_add_format(dimap)
gdal_add_format(gff)
gdal_add_format(cosar)
gdal_add_format(pds)
gdal_add_format(adrg)
gdal_add_format(coasp)
gdal_add_format(tsx)
gdal_add_format(terragen)
gdal_add_format(blx)
gdal_add_format(msgn)
gdal_add_format(til)
gdal_add_format(r)
gdal_add_format(northwood)
gdal_add_format(saga)
gdal_add_format(xyz)
gdal_add_format(hf2)
gdal_add_format(kmlsuperoverlay)
gdal_add_format(ctg)
gdal_add_format(e00grid)
gdal_add_format(zmap)
gdal_add_format(ngsgeoid)
gdal_add_format(iris)
gdal_add_format(map)
gdal_add_format(cals)
gdal_add_format(safe)
gdal_add_format(sentinel2)
gdal_add_format(derived)
gdal_add_format(prf)

gdal_add_format(mrf)
gdal_add_format(webp)
gdal_add_format(wcs)
gdal_add_format(wms)
gdal_add_format(plmosaic)
gdal_add_format(wmts)
gdal_add_format(grib)
gdal_add_format(openjpeg)
gdal_add_format(jpeg2000)
gdal_add_format(netcdf)
gdal_add_format(hdf5)
gdal_add_format(ogdi)
gdal_add_format(jpeg)
gdal_add_format(gta)
gdal_add_format(pcraster)
gdal_add_format(fits)
gdal_add_format(gif)

###########################################
## optional formats
gdal_add_format_option(png "PNG")
gdal_add_format_option(bsb "BSB")
gdal_add_format_option(aigrid "AIGRID")
gdal_add_format_option(arg "ARG")
gdal_add_format_option(usgsdem "USGSDEM")
gdal_add_format_option(bmp "BMP")
gdal_add_format_option(airsar "AirSAR")
gdal_add_format_option(raw "RAW")

## FIXME: temporary disables incomplete hdf4 driver cmake recipe
#add_subdirectory(hdf4)

# OPTIONAL Formats
#
add_subdirectory(pcidsk)
# libz dependency
add_subdirectory(rik)
gdal_add_format_option(ozi "OZI")
gdal_add_format_option(pdf "PDF")
# sqlite dependency
gdal_add_format_option(rasterlite "RasterLite")
gdal_add_format_option(mbtiles "MBTile")
# optional drivers
gdal_add_format_option(postgisraster "PostGIS raster")
gdal_add_format_option(jpegls "JPEG LS")
gdal_add_format_option(bpg "JPG")
gdal_add_format_option(dods "DODS")
gdal_add_format_option(dds "DDS")
gdal_add_format_option(kea "Kea")
gdal_add_format_option(grass "GRASS")
gdal_add_format_option(zlib "ZLib")

# driver with proprietary libraries
gdal_add_format_option(jp2kak JP2KAK)
gdal_add_format_option(jpipkak JPIPKAK)
gdal_add_format_option(jp2lura JP2LURA)


set(LIB_CSOURCES
    gdalallregister.cpp
)

set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} PARENT_SCOPE)
add_library(${LIB_NAME} OBJECT ${LIB_CSOURCES})

