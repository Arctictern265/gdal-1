# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru
# ******************************************************************************
# * Copyright (C) 2013 Bishop
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

set(LIB_NAME "frmts_postgisraster")
project ("lib${LIB_NAME}")

include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/vrt)  

find_package(POSTGRES REQUIRED)
if(POSTGRES_FOUND)
	include_directories(${POSTGRES_INCLUDE_DIR})
	add_definitions(-DHAVE_PG)
	set(GDAL_HAVE_PG ON CACHE INTERNAL "GDAL_HAVE_PG")
endif(POSTGRES_FOUND)

set(LIB_HHEADERS ${LIB_INST_HEADERS}
    postgisraster.h
)

set(LIB_CSOURCES
	postgisrasterdataset.cpp
	postgisrasterdriver.cpp
	postgisrasterrasterband.cpp
	postgisrastertiledataset.cpp
	postgisrastertilerasterband.cpp
	postgisrastertools.cpp
)

if(GDAL_ENABLE_FRMT_POSTGISRASTER)
    set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
    add_library(${LIB_NAME} OBJECT ${LIB_HHEADERS} ${LIB_CSOURCES})
endif()

if(POSTGRES_FOUND)
    if(WIN32)
		set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${POSTGRES_LIBRARY} Ws2_32.lib Secur32.lib PARENT_SCOPE)
	else()
		set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${POSTGRES_LIBRARY} PARENT_SCOPE)
    endif()
endif()

install(FILES ${LIB_INST_HEADERS} DESTINATION include/gdal)
