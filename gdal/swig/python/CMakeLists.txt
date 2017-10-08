# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru,
# *			Hiroshi Miura <miurahr@linux.com>
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

find_package(PythonInterp REQUIRED)
find_package(PythonLibs REQUIRED)
include(MacroSwigBindings)

INCLUDE_DIRECTORIES( ${PYTHON_INCLUDE_PATH} ${GDAL_INCLUDE_DIR})

MACRO_SWIG_BINDINGS(python)

set(SWIG_PYTHON_SOURCES
        README.txt
        gdal.py  gdalconst.py  gdalnumeric.py  gnm.py  ogr.py  osr.py  setup.py
        osgeo/__init__.py  osgeo/gdal_array.py osgeo/gdalnumeric.py  osgeo/ogr.py
        osgeo/gdal.py      osgeo/gdalconst.py  osgeo/gnm.py          osgeo/osr.py
)
file(MAKE_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/python/osgeo/)
foreach(f ${SWIG_PYTHON_SOURCES})
    add_custom_command(
        OUTPUT ${GDAL_ROOT_BINARY_DIR}/swig/python/${f}
        COMMAND ${CMAKE_COMMAND} -E copy ${GDAL_ROOT_SOURCE_DIR}/swig/python/${f} ${GDAL_ROOT_BINARY_DIR}/swig/python/${f}
        DEPENDS ${GDAL_ROOT_SOURCE_DIR}/swig/python/${f}
    )
    list(APPEND SWIG_PYTHON_SOURCES_LIST ${GDAL_ROOT_BINARY_DIR}/swig/python/${f})
endforeach()
set_source_files_properties(${SWIG_PYTHON_SOURCES_LIST} PROPERTIES GENERATED 1)

set(GDAL_SWIG_PYTHON_INCLUDE_DIR
        "${GDAL_ROOT_BINARY_DIR}/port:${GDAL_ROOT_SOURCE_DIR}/apps:${GDAL_ROOT_SOURCE_DIR}/port:${GDAL_ROOT_SOURCE_DIR}/gcore:${GDAL_ROOT_SOURCE_DIR}/alg:${GDAL_ROOT_SOURCE_DIR}/ogr:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts:${GDAL_ROOT_SOURCE_DIR}/gnm")
set(GDAL_SWIG_PYTHON_LIBRARY_DIR "${GDAL_ROOT_BINARY_DIR}")
CONFIGURE_FILE(${CMAKE_MODULE_PATH}/setup.cfg.in ${GDAL_ROOT_BINARY_DIR}/swig/python/setup.cfg)

add_custom_target(gdal_python ALL ${PYTHON_EXECUTABLE} setup.py build
        DEPENDS gdal_python_wrappers ${SWIG_PYTHON_SOURCES_LIST}
        WORKING_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/python
        COMMENT "generating python binding"
        SOURCES ${SWIG_PYTHON_SOURCES_LIST}
)

#INSTALL(TARGETS gdal_python LIBRARY DESTINATION ${PYTHON_VENDOR_ARCH_DIR})

