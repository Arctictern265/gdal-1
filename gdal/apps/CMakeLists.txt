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

# generate gdal-config
project(gdal-config)
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
    set(GDAL_PREFIX "/usr/local") # default
else()
    set(GDAL_PREFIX ${CMAKE_INSTALL_PREFIX})
endif()
set(GDAL_ROOT "${GDAL_PREFIX}/lib")
#
set(CONFIG_PREFIX ${GDAL_PREFIX})
set(CONFIG_CFLAGS "-I${GDAL_PREFIX}/include")
set(CONFIG_DATA "${GDAL_PREFIX}/share/gdal/${GDAL_MAJOR_VERSION}.${GDAL_MINOR_VERSION}")
set(CONFIG_VERSION ${GDAL_VERSION})
# always yes
set(CONFIG_OGR_ENABLED "yes")
# generate dep-libs and cflags
set(_DEP_LIBS "")
set(_LINKFLAGS "")
foreach(_lib ${GDAL_TARGET_LINK_LIB})
    get_filename_component(_lib_name ${_lib} NAME_WE)
    string(REGEX REPLACE "^lib" "" _name ${_lib_name})
    list(APPEND _DEP_LIBS "-l${_name} ")
    get_filename_component(_lib_dir ${_lib} PATH)
    list(APPEND _LINKFLAGS "-L${_lib_dir} ")
endforeach()
list(REMOVE_DUPLICATES _DEP_LIBS )
list(REMOVE_DUPLICATES _LINKFLAGS )
string(REPLACE ";" " " CONFIG_DEP_LIBS "${_DEP_LIBS}")
string(REPLACE ";" " " CONFIG_LIBS "${LINKFLAGS}")
#
if(GDAL_ENABLE_GNM)
    set(CONFIG_GNM_ENABLED "yes")
else()
    set(CONFIG_GNM_ENABLED "no")
endif()
#
string(REPLACE ";" " " CONFIG_FORMATS "${GDAL_FORMATS}")
#
configure_file(${CMAKE_MODULE_PATH}/gdal-config.in ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/gdal-config)
file(COPY ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/gdal-config
        DESTINATION ${GDAL_ROOT_BINARY_DIR}/apps/
        FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
install(FILES ${GDAL_ROOT_BINARY_DIR}/apps/gdal-config DESTINATION bin
        PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

