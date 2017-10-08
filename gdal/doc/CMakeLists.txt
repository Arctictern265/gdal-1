# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru, Hiroshi Miura
# ******************************************************************************
# * Copyright (C) 2012,2013 Bishop
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

set(PROJECT_NAME "gdal_docs")

# Documentation rules
find_package(Doxygen)
IF(DOXYGEN_FOUND)
    # doxygen custom configurations
    set(GDAL_DOXYGEN_OUTPUT_DIRECTORY "${GDAL_ROOT_BINARY_DIR}")
    set(GDAL_DOXYGEN_PROJECT_NAME "GDAL")
    set(GDAL_DOXYGEN_LANGUAGE "English")
    set(GDAL_DOXYGEN_JAVADOC_AUTOBRIEF "YES")
    set(GDAL_DOXYGEN_EXTRACT_LOCAL_CLASSES "NO")
    set(GDAL_DOXYGEN_INPUT
            "port \
                         gcore \
                         frmts/gdalallregister.cpp \
                         alg \
                         frmts/vrt \
                         doc \
                         apps \
                         ogr \
                         ogr/ogrsf_frmts \
                         ogr/ogrsf_frmts/generic \
                         ogr/ogrsf_frmts/geojson/ogrgeojsonwriter.cpp \
                         ogr/ogrsf_frmts/kml/ogr2kmlgeometry.cpp \
                         swig/python/scripts \
                         gnm"
            )
    set(GDAL_DOXYGEN_EXAMPLE_PATH
            "apps \
             frmts \
             frmts/jdem"
            )
    set(GDAL_DOXYGEN_IMAGE_PATH ${GDAL_ROOT_SOURCE_DIR}/doc/grid)
    set(GDAL_DOXYGEN_LAYOUT_FILE ${GDAL_ROOT_SOURCE_DIR}/DoxygenLayout.xml)
    configure_file(${CMAKE_SOURCE_DIR}/cmake/Doxyfile.in ${GDAL_ROOT_BINARY_DIR}/Doxyfile)

    # Generate translated docs. Should go first, because index.html page should
    # be overwritten with the main one later
    #    add_custom_command(
    #        OUTPUT ${GDAL_ROOT_BINARY_DIR}/html/classes.html
    #        COMMAND ${DOXYGEN_EXECUTABLE} -w html html/header.html html/footer.html html/stylesheet.css
    #        MAIN_DEPENDENCY ${GDAL_ROOT_BINARY_DIR}/Doxyfile
    #        WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}
    #	)

    # prepare language headers
    add_custom_command(
            OUTPUT ${GDAL_ROOT_BINARY_DIR}/html/header_ru.html
            COMMAND ${CMAKE_COMMAND}
            ARGS
            -Dinfile:FILEPATH=${GDAL_ROOT_SOURCE_DIR}/html/header.html
            -Doutfile:FILEPATH=${GDAL_ROOT_SOURCE_DIR}/html/header_ru.html
            -Dfrom:STRING="iso-8859-1"
            -Dto:STRING="utf-8"
            -P ${CMAKE_MODULE_PATH}/ReplaceStr.cmake
            MAIN_DEPENDENCY
            ${GDAL_ROOT_SOURCE_DIR}/html/header.html
            WORKING_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/html
    )
    add_custom_command(
            OUTPUT ${GDAL_ROOT_BINARY_DIR}/html/header_br.html
            COMMAND ${CMAKE_COMMAND} -E copy
            ${GDAL_ROOT_SOURCE_DIR}/html/header.html
            ${GDAL_ROOT_BINARY_DIR}/html/header_br.html
            DEPENDS ${GDAL_ROOT_SOURCE_DIR}/html/header.html
    )
    add_custom_command(
            OUTPUT ${GDAL_ROOT_BINARY_DIR}/html/header.html
            COMMAND ${CMAKE_COMMAND} -E copy
            ${GDAL_ROOT_SOURCE_DIR}/html/header.html
            ${GDAL_ROOT_BINARY_DIR}/html/header.html
            DEPENDS ${GDAL_ROOT_SOURCE_DIR}/html/header.html
    )
    add_custom_command(
            OUTPUT ${GDAL_ROOT_BINARY_DIR}/html/footer.html
            COMMAND ${CMAKE_COMMAND} -E copy
            ${GDAL_ROOT_SOURCE_DIR}/html/footer.html
            ${GDAL_ROOT_BINARY_DIR}/html/footer.html
            DEPENDS ${GDAL_ROOT_SOURCE_DIR}/html/footer.html
    )
    add_custom_command(
            OUTPUT ${GDAL_ROOT_BINARY_DIR}/html/stylesheet.css
            COMMAND ${CMAKE_COMMAND} -E copy
            ${GDAL_ROOT_SOURCE_DIR}/html/stylesheet.css
            ${GDAL_ROOT_BINARY_DIR}/html/stylesheet.css
            DEPENDS ${GDAL_ROOT_SOURCE_DIR}/html/stylesheet.css
    )
    # run main doxygen
    add_custom_command(
            OUTPUT ${GDAL_ROOT_BINARY_DIR}/html/index.html
            COMMAND ${DOXYGEN_EXECUTABLE} ${GDAL_ROOT_BINARY_DIR}/Doxyfile
            MAIN_DEPENDENCY ${GDAL_ROOT_BINARY_DIR}/Doxyfile
            WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}
    )

    # doxygen ru configurations
    set(GDAL_DOXYGEN_OUTPUT_DIRECTORY "${GDAL_ROOT_BINARY_DIR}")
    set(GDAL_DOXYGEN_PROJECT_NAME "RU")
    set(GDAL_DOXYGEN_LANGUAGE "Russian")
    set(GDAL_DOXYGEN_JAVADOC_AUTOBRIEF "NO")
    set(GDAL_DOXYGEN_EXTRACT_LOCAL_CLASSES "YES")
    set(GDAL_DOXYGEN_INPUT "gdal_building_ru.dox gdal_datamodel_ru.dox gdal_tutorial_ru.dox index_ru.dox")
    set(GDAL_DOXYGEN_EXAMPLE_PATH "")
    set(GDAL_DOXYGEN_IMAGE_PATH "")
    set(GDAL_DOXYGEN_LAYOUT_FILE "")
    configure_file(${CMAKE_SOURCE_DIR}/cmake/Doxyfile.in ${GDAL_ROOT_BINARY_DIR}/Doxyfile_ru)
    add_custom_command(
            OUTPUT ${GDAL_ROOT_BINARY_DIR}/html/index_ru.html
            COMMAND ${DOXYGEN_EXECUTABLE} ${GDAL_ROOT_BINARY_DIR}/Doxyfile_ru
            MAIN_DEPENDENCY ${GDAL_ROOT_BINARY_DIR}/Doxyfile_ru
            WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}/doc/ru
    )

    # copy rest of files
    file(GLOB OTHER_DOCS
            ${GDAL_ROOT_SOURCE_DIR}/doc/images/act-logo.png
            ${GDAL_ROOT_SOURCE_DIR}/doc/images/cadcorp_logo.jpg
            ${GDAL_ROOT_SOURCE_DIR}/doc/images/foss4g2013.png
            ${GDAL_ROOT_SOURCE_DIR}/doc/images/foss4g2014.png
            ${GDAL_ROOT_SOURCE_DIR}/doc/images/foss4g2017.png
            ${GDAL_ROOT_SOURCE_DIR}/doc/images/i3-logo.jpg
            ${GDAL_ROOT_SOURCE_DIR}/doc/images/ingres-logo.png
            ${GDAL_ROOT_SOURCE_DIR}/doc/images/OSGeo_project.png
            ${GDAL_ROOT_SOURCE_DIR}/doc/images/safe-logo.png
            ${GDAL_ROOT_SOURCE_DIR}/doc/images/src-logo.png
            ${GDAL_ROOT_SOURCE_DIR}/doc/images/waypoint_logo.png
            ${GDAL_ROOT_SOURCE_DIR}/doc/grid/*.png
            ${GDAL_ROOT_SOURCE_DIR}/frmts/*.html
            ${GDAL_ROOT_SOURCE_DIR}/frmts/*/frmt_*.html
            ${GDAL_ROOT_SOURCE_DIR}/frmts/openjpeg/*.xml
            ${GDAL_ROOT_SOURCE_DIR}/frmts/wms/frmt_*.xml
            ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/*/frmt_*.html
            ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/*/dev_*.html
            #    ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geopackage_aspatial.html
            ${GDAL_ROOT_SOURCE_DIR}/ogr/*.gif
            ${GDAL_ROOT_SOURCE_DIR}/data/gdalicon.png
            ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/ogr_formats.html
            ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/ogr_formats.html
            ${GDAL_ROOT_SOURCE_DIR}/ogr/ogr_feature_style.html
            )
    add_custom_target(copy_other_docs)
    set(DocsTargetDir ${GDAL_ROOT_BINARY_DIR}/html)
    foreach(f ${OTHER_DOCS})
        add_custom_command(TARGET copy_other_docs PRE_BUILD
                COMMAND ${CMAKE_COMMAND} -E
                copy ${f} ${DocsTargetDir})
    endforeach()
    add_custom_target(docs
            DEPENDS
            #            ${GDAL_ROOT_BINARY_DIR}/html/classes.html
            ${GDAL_ROOT_BINARY_DIR}/html/index.html
            ${GDAL_ROOT_BINARY_DIR}/html/header.html
            ${GDAL_ROOT_BINARY_DIR}/html/footer.html
            ${GDAL_ROOT_BINARY_DIR}/html/stylesheet.css
            ${GDAL_ROOT_BINARY_DIR}/html/header_br.html
            ${GDAL_ROOT_BINARY_DIR}/html/header_ru.html
            ${GDAL_ROOT_BINARY_DIR}/html/index_ru.html
            copy_other_docs
            )
ENDIF()