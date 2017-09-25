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

macro(MACRO_SWIG_BINDINGS_INNER binding target)
    set(SWIG_INPUT  ${CMAKE_CURRENT_SOURCE_DIR}/swig/include/${target}.i )
    set(SWIG_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${target}_wrap.cpp)
    add_custom_command(
        OUTPUT  ${SWIG_OUTPUT}
        set(SWIG_ARGS "-Wall -I${CMAKE_CURRENT_SOURCE_DIR}/swig/include -I${CMAKE_CURRENT_SOURCE_DIR}/swig/include/${binding} -I${CMAKE_CURRENT_SOURCE_DIR}/swig/include/${binding}/docs")
        COMMAND ${SWIG_EXECUTABLE} ${SWIG_ARGS} -I${GDAL_SOURCE_ROOT_DIR} -c++ -${binding} -o ${SWIG_OUTPUT} ${SWIG_INPUT}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/swig/include/*.i ${CMAKE_CURRENT_SOURCE_DIR}/swig/include/${binding}/*.i
    )
endmacro()

macro(MACRO_SWIG_BINDINGS binding)
    find_package(SWIG REQUIRED)
    # for gdalconst.i
    set(SWIG_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/gdalconst_wrap.c )
    set(SWIG_INPUT  ${CMAKE_CURRENT_SOURCE_DIR}/swig/include/gdalconst.i )
    add_custom_command(
        OUTPUT  ${SWIG_OUTPUT}
        set(SWIG_ARGS "-Wall -I${CMAKE_CURRENT_SOURCE_DIR}/swig/include -I${CMAKE_CURRENT_SOURCE_DIR}/swig/include/${binding} -I${CMAKE_CURRENT_SOURCE_DIR}/swig/include/${binding}/docs")
        COMMAND ${SWIG_EXECUTABLE} ${SWIG_ARGS} ${SWIG_DEFINES} -I${GDAL_SOURCE_ROOT} -${binding} -o ${SWIG_OUTPUT} ${SWIG_INPUT}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/swig/include/*.i ${CMAKE_CURRENT_SOURCE_DIR}/swig/include/${binding}/*.i
    )
    # other wrappers
    MACRO_SWIG_BINDINGS_INNER(${binding} gdal)
    MACRO_SWIG_BINDINGS_INNER(${binding} ogr )
    MACRO_SWIG_BINDINGS_INNER(${binding} osr )
    MACRO_SWIG_BINDINGS_INNER(${binding} gnm )
endmacro()