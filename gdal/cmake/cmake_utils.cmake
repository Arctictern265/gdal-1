# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru,
# *         Hiroshi Miura
# ******************************************************************************
# * Copyright (C) 2017 Hiroshi Miura
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

macro(apps_macro APP_NAME APP_CSOURCES APP_HHEADERS)
  project (${APP_NAME})
  add_executable(${APP_NAME} ${APP_CSOURCES} ${APP_HHEADERS})

  set_target_properties(${APP_NAME}
          PROPERTIES PROJECT_LABEL ${APP_NAME}
          VERSION ${GDAL_VERSION}
          SOVERSION 1
          ARCHIVE_OUTPUT_DIRECTORY ${GDAL_ROOT_BINARY_DIR}
          LIBRARY_OUTPUT_DIRECTORY ${GDAL_ROOT_BINARY_DIR}
          RUNTIME_OUTPUT_DIRECTORY ${GDAL_ROOT_BINARY_DIR}
          )

  target_link_libraries(${APP_NAME} ${GDAL_LIB_NAME})

  install(TARGETS ${APP_NAME} DESTINATION bin)
endmacro()

macro(gdal_add_definitions defn)
  if("${${defn}}" STREQUAL "1")
    add_definitions(-D${defn})
  endif()
endmacro()

function(TRANSFORM_VERSION numerical_result version)
  # internal_version ignores everything in version after any character that
  # is not 0-9 or ".".  This should take care of the case when there is
  # some non-numerical data in the patch version.
  #message(STATUS "DEBUG: version = ${version}")
  string(REGEX REPLACE "^([0-9.]+).*$" "\\1" internal_version ${version})

  # internal_version is normally a period-delimited triplet string of the form
  # "major.minor.patch", but patch and/or minor could be missing.
  # Transform internal_version into a numerical result that can be compared.
  string(REGEX REPLACE "^([0-9]*).+$" "\\1" major ${internal_version})
  string(REGEX REPLACE "^[0-9]*\\.([0-9]*).*$" "\\1" minor ${internal_version})
  string(REGEX REPLACE "^[0-9]*\\.[0-9]*\\.([0-9]*)$" "\\1" patch ${internal_version})

  if(NOT patch MATCHES "[0-9]+")
    set(patch 0)
  endif(NOT patch MATCHES "[0-9]+")

  if(NOT minor MATCHES "[0-9]+")
    set(minor 0)
  endif(NOT minor MATCHES "[0-9]+")

  if(NOT major MATCHES "[0-9]+")
    set(major 0)
  endif(NOT major MATCHES "[0-9]+")

  set(factor 100)
  if(minor GREATER 99)
      set(factor 1000)
  endif()
  if(patch GREATER 99)
      set(factor 1000)
  endif()
  math(EXPR internal_numerical_result
          "${major}*${factor}*${factor} + ${minor}*${factor} + ${patch}"
          )
  set(${numerical_result} ${internal_numerical_result} PARENT_SCOPE)
endfunction(TRANSFORM_VERSION)
