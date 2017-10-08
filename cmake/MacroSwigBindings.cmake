# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author:   Hiroshi Miura <miurahr@linux.com>
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
    set(SWIG_COMMON_INCLUDES
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/Band.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/CodeTable.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/cpl.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/cpl_exceptions.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/Dataset.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/Driver.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/gdal.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/gdal_array.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/gdal_typemaps.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/gnm.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/MajorObject.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/ogr.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/ogr_error_map.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/Operations.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/osr.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/RasterAttributeTable.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/Transform.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/XMLNode.i
        )

macro(_MACRO_SWIG_BINDINGS binding target)
    set(SWIG_OUTPUT ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions/${target}_wrap.cpp)
    set(SWIG_INPUT  ${GDAL_ROOT_SOURCE_DIR}/swig/include/${target}.i)
    set(GDAL_SWIG_DEPENDS
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/${binding}/typemaps_${binding}.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/${binding}/${target}_${binding}.i
    )
    set(SWIG_ARGS -Wall -I${GDAL_ROOT_SOURCE_DIR}/swig/include -I${GDAL_ROOT_SOURCE_DIR}/swig/include/${binding} -I${GDAL_ROOT_SOURCE_DIR}/swig/include/${binding}/docs)
    set(SWIG_ARGS -threads -outdir osgeo ${SWIG_ARGS})
    add_custom_command(
        OUTPUT  ${SWIG_OUTPUT}
        COMMAND ${SWIG_EXECUTABLE} ${SWIG_ARGS} -I${GDAL_SOURCE_ROOT_DIR} -c++ -${binding} -o ${SWIG_OUTPUT} ${SWIG_INPUT}
        WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}/swig/${binding}
        DEPENDS ${GDAL_SWIG_COMMON_INCLUDE} ${GDAL_SWIG_DEPENDS}
    )
endmacro()

macro(MACRO_SWIG_BINDINGS binding)
    file(MAKE_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions )
    find_package(SWIG REQUIRED)
    # for gdalconst.i
    set(SWIG_OUTPUT ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions/gdalconst_wrap.c )
    set(SWIG_INPUT  ${GDAL_ROOT_SOURCE_DIR}/swig/include/gdalconst.i )
    set(SWIG_ARGS -Wall -I${GDAL_ROOT_SOURCE_DIR}/swig/include -I${GDAL_ROOT_SOURCE_DIR}/swig/include/${binding} -I${GDAL_ROOT_SOURCE_DIR}/swig/include/${binding}/docs)
    set(SWIG_ARGS -threads -outdir osgeo ${SWIG_ARGS})
    set(GDAL_SWIG_DEPENDS
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/${binding}/typemaps_${binding}.i
    )
    add_custom_command(
        OUTPUT  ${SWIG_OUTPUT}
        COMMAND ${SWIG_EXECUTABLE} ${SWIG_ARGS} ${SWIG_DEFINES} -I${GDAL_ROOT_SOURCE_ROOT} -${binding} -o ${SWIG_OUTPUT} ${SWIG_INPUT}
        WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}/swig/${binding}
        DEPENDS ${GDAL_SWIG_COMMON_INCLUDE} ${GDAL_SWIG_DEPENDS} ${SWIG_INPUT}
    )
    # for gdal_array_wrap.cpp
    set(SWIG_OUTPUT ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions/gdal_array_wrap.cpp )
    set(SWIG_INPUT  ${GDAL_ROOT_SOURCE_DIR}/swig/include/gdal_array.i )
    set(SWIG_ARGS -Wall -I${GDAL_ROOT_SOURCE_DIR}/swig/include -I${GDAL_ROOT_SOURCE_DIR}/swig/include/${binding} -I${GDAL_ROOT_SOURCE_DIR}/swig/include/${binding}/docs)
    set(SWIG_ARGS -threads -outdir osgeo ${SWIG_ARGS})
    set(GDAL_SWIG_DEPENDS
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/${binding}/typemaps_${binding}.i
    )
    add_custom_command(
        OUTPUT  ${SWIG_OUTPUT}
        COMMAND ${SWIG_EXECUTABLE} ${SWIG_ARGS} ${SWIG_DEFINES} -I${GDAL_ROOT_SOURCE_ROOT} -c++ -${binding} -o ${SWIG_OUTPUT} ${SWIG_INPUT}
        WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}/swig/${binding}
        DEPENDS ${GDAL_SWIG_COMMON_INCLUDE} ${GDAL_SWIG_DEPENDS} ${SWIG_INPUT}
    )

    # other wrappers
    _MACRO_SWIG_BINDINGS(${binding} gdal)
    _MACRO_SWIG_BINDINGS(${binding} ogr )
    _MACRO_SWIG_BINDINGS(${binding} osr )
    _MACRO_SWIG_BINDINGS(${binding} gnm )
    add_custom_target(gdal_${binding}_wrappers
            DEPENDS
                ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions/gdal_array_wrap.cpp
                ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions/gdalconst_wrap.c
                ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions/gdal_wrap.cpp
                ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions/ogr_wrap.cpp
                ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions/osr_wrap.cpp
                ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions/gnm_wrap.cpp
            )
endmacro()
