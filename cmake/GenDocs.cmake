
# Generate translated docs. Should go first, because index.html page should
# be overwritten with the main one later
add_custom_command(
        OUTPUT ${GDAL_ROOT_BINARY_DIR}/html/index.html
        COMMAND ${DOXYGEN_EXECUTABLE} -w html html/header.html html/footer.html html/stylesheet.css
        MAIN_DEPENDENCY ${GDAL_ROOT_SOURCE_DIR}/Doxyfile /${GDAL_ROOT_SOURCE_DIR}/html/header.html
        WORKING_DIRECTORY ${GDAL_ROOT_BINARY_DIR}
)
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
file(GENERATE
        OUTPUT %{GDAL_ROOT_BINARY_DIR}/html/header_br.html
        INPUT ${GDAL_ROOT_SOURCE_DIR}/doc/html/header.html
        )
add_custom_command(
        OUTPUT ${GDAL_ROOT_BINARY_DIR}/doc/html/index.html
        COMMAND ${DOXYGEN_EXECUTABLE}
        MAIN_DEPENDENCY ${GDAL_ROOT_SOURCE_DIR}/Doxyfile
        WORKING_DIRECTORY ${GDAL_ROOT_BINARY_DIR}
)
add_custom_command(
        OUTPUT index.html
        COMMAND ${DOXYGEN_EXECUTABLE}
        WORKING_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/doc/ru
        MAIN_DEPENDENCY ${GDAL_ROOT_BINARY_DIR}/doc/ru/
)
file(COPY
        ${GDAL_ROOT_BINARY_DIR}/doc/ru/html/index.html
        ${GDAL_ROOT_BINARY_DIR}/doc/ru/html/*
        DESTINATION
        ${GDAL_ROOT_BINARY_DIR}/html
        )
file(COPY
        ${GDAL_ROOT_BINARY_DIR}/doc/br/html/*
        DESTINATION
        ${GDAL_ROOT_BINARY_DIR}/html
        )

file(COPY
        ${GDAL_ROOT_SOURCE_DIR}/data/gdalicon.png
        ${GDAL_ROOT_SOURCE_DIR}/doc/images/*
        ${GDAL_ROOT_SOURCE_DIR}/doc/grid/*.png
        ${GDAL_ROOT_SOURCE_DIR}/frmts/*.html
        ${GDAL_ROOT_SOURCE_DIR}/frmts/*/frmt_*.html
        ${GDAL_ROOT_SOURCE_DIR}/frmts/openjpeg/*.xml
        ${GDAL_ROOT_SOURCE_DIR}/frmts/wms/frmt_*.xml
        ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/*/frmt_*.html
        ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/*/dev_*.html
        ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/ogr_formats.html
        ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/ogr_formats.html
        ${GDAL_ROOT_SOURCE_DIR}/ogr/ogr_feature_style.html
        ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geopackage_aspatial.html
        ${GDAL_ROOT_SOURCE_DIR}/ogr/*.gif
        DESTINATION
        ${GDAL_ROOT_BINARY_DIR}/html
        )
