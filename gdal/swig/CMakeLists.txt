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

option(PYTHON_BINDING "Build the Python binding" OFF)
if(PYTHON_BINDING)
    message("Python support is added.")
    find_package(SWIG REQUIRED)
    find_package(PythonLibs REQUIRED)
    include(${SWIG_USE_FILE})
    set(CMAKE_SWIG_FLAGS "")
    include_directories(${PYTHON_INCLUDE_DIRS})
    #swig_add_module(target python include/gdal.i ${SOURCES})
    #swig_link_libraries(target ${PYTHON_LIBRARIES})
endif()


option(JAVA_BINDING "Build the JAVA binding" OFF)
if(JAVA_BINDING)
    message("JAVA support is added.")
endif()


option(PERL_BINDING "Build the Perl binding" OFF)
if(PERL_BINDING)
    message("Perl support is added.")
endif()


option(PHP_BINDING "Build the PHP binding" OFF)
if(PHP_BINDING)
    message("PHP support is added.")
endif()


option(CSHARP_BINDING "Build the C# binding" OFF)
if(CSHARP_BINDING)
    message("C# support is added.")
endif()


option(RUBY_BINDING "Build the Ruby binding" OFF)
if(RUBY_BINDING)
    message("Ruby support is added.")
endif()


