# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru
# ******************************************************************************
# * Copyright (C) 2012 Bishop
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

include_directories(${GDAL_ROOT_SOURCE_DIR}/gcore/)
include_directories(${GDAL_ROOT_SOURCE_DIR}/alg/)
include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/vrt)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/generic)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson/libjson)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/mem)

include_directories(${GDAL_ROOT_BINARY_DIR}/port)

set(LIB_NAME "gdal_apps")

set(LIB_HHEADERS
    commonutils.h
)

set(LIB_CSOURCES
    gdalinfo_lib.cpp
    gdalbuildvrt_lib.cpp
    gdal_grid_lib.cpp
    gdal_translate_lib.cpp
    gdalwarp_lib.cpp
    commonutils.cpp
    ogr2ogr_lib.cpp
)

set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
add_library(${LIB_NAME} OBJECT ${LIB_HHEADERS} ${LIB_CSOURCES})

include(GdalUtils)
option(GDAL_BUILD_APPS "Set ON to build apps" ON)
if(GDAL_BUILD_APPS)

#gdalinfo
	set(GDALINFO_HHEADERS
        gdal_utils_priv.h
	)

	set(GDALINFO_CSOURCES
		gdalinfo_bin.cpp
	)

	apps_macro("gdalinfo" "${GDALINFO_CSOURCES}" "${GDALINFO_HHEADERS}")
    
    	
#gdalbuildvrt    
	set(gdalbuildvrt_HHEADERS
        gdal_utils_priv.h
	)

	set(gdalbuildvrt_CSOURCES
        gdalbuildvrt_bin.cpp
	)

	apps_macro("gdalbuildvrt" "${gdalbuildvrt_CSOURCES}" "${gdalbuildvrt_HHEADERS}")	
	
#gdaladdo    
	set(GDALADDO_HHEADERS
        gdal_utils_priv.h
	)

	set(GDALADDO_CSOURCES
		gdaladdo.cpp
	)

	apps_macro("gdaladdo" "${GDALADDO_CSOURCES}" "${GDALADDO_HHEADERS}")	
    
#gdal_grid   
    set(gdal_grid_HHEADERS
        gdal_utils_priv.h
        commonutils.h
    )

    set(gdal_grid_CSOURCES
        gdal_grid_bin.cpp
    )

apps_macro("gdal_grid" "${gdal_grid_CSOURCES}" "${gdal_grid_HHEADERS}")
    
#gdal_translate    
	include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/)
	set(gdal_translate_HHEADERS
        gdal_utils_priv.h
        commonutils.h
	)

	set(gdal_translate_CSOURCES
        gdal_translate_bin.cpp
	)

	apps_macro("gdal_translate" "${gdal_translate_CSOURCES}" "${gdal_translate_HHEADERS}")    
    
#gdalwarp
	set(gdalwarp_HHEADERS
        commonutils.h    
	)

	set(gdalwarp_CSOURCES
        gdalwarp_bin.cpp
	)

	apps_macro("gdalwarp" "${gdalwarp_CSOURCES}" "${gdalwarp_HHEADERS}")  
    
#gdal_contour
	set(gdal_contour_HHEADERS
        commonutils.h
	)

	set(gdal_contour_CSOURCES
		gdal_contour.cpp
	)

	apps_macro("gdal_contour" "${gdal_contour_CSOURCES}" "${gdal_contour_HHEADERS}") 
    
#gdallocationinfo   
	include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/)

	set(gdallocationinfo_HHEADERS
	)

	set(gdallocationinfo_CSOURCES
		gdallocationinfo.cpp
	)
	apps_macro("gdallocationinfo" "${gdallocationinfo_CSOURCES}" "${gdallocationinfo_HHEADERS}")
	
#ogrinfo    
	set(ogrinfo_HHEADERS
        commonutils.h
	)

	set(ogrinfo_CSOURCES
		ogrinfo.cpp
	)
	apps_macro("ogrinfo" "${ogrinfo_CSOURCES}" "${ogrinfo_HHEADERS}")
    
#ogr2ogr    
	set(ogr2ogr_HHEADERS
	)

	set(ogr2ogr_CSOURCES
        ogr2ogr_bin.cpp
	)
	apps_macro("ogr2ogr" "${ogr2ogr_CSOURCES}" "${ogr2ogr_HHEADERS}")    

endif(GDAL_BUILD_APPS)

if(GDAL_ENABLE_OGR)

#test_ogrsf.cpp
	set(TEST_OGRSF_HHEADERS
        commonutils.h
	)

	set(TEST_OGRSF_CSOURCES
		test_ogrsf.cpp
	)

	apps_macro("test_ogrsf" "${TEST_OGRSF_CSOURCES}" "${TEST_OGRSF_HHEADERS}")
endif()