# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru
# *         Hiroshi Miura <miurahr@linux.com>
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

set(LIB_NAME "frmts_jpipkak")
project ("lib${LIB_NAME}")

include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr)
include_directories(${GDAL_ROOT_SOURCE_DIR}/gcore)

set(LIB_HHEADERS
        jpipkak_headers.h
        jpipkakdataset.h
)

set(LIB_CSOURCES
        jpipkakdataset.cpp
)

if(GDAL_ENABLE_FRMT_JPIPKAK)
    set(KAKDIR ${KAKADU_DIRECTORY})
    include_directories($(KAKDIR)/coresys/common;$(KAKDIR)/apps/compressed_io;
	$(KAKDIR)/apps/jp2;$(KAKDIR)/apps/image;$(KAKDIR)/apps/args;
	$(KAKDIR)/apps/support;$(KAKDIR)/apps/kdu_compress;
    $(KAKDIR)/apps/caching_sources)
    add_definitions(-DFRMT_jp2kak)
    set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
    add_library(${LIB_NAME} OBJECT ${LIB_HHEADERS} ${LIB_CSOURCES})
endif()
