# Find KEA - KEA library
# ~~~~~~~~~
#
# Copyright (c) 2017, Hiroshi Miura <miurahr@linux.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# If it's found it sets DAP_FOUND to TRUE
# and following variables are set:
#    KEA_INCLUDE_DIR
#    KEA_LIBRARY
#    KEA_VERSION
#
# FIND_PATH and FIND_LIBRARY normally search standard locations
# before the specified paths. To search non-standard paths first,
# FIND_* is invoked first with specified paths and NO_DEFAULT_PATH
# and then again with no specified paths to search the default
# locations. When an earlier FIND_* succeeds, subsequent FIND_*s
# searching for the same item do nothing.

# try to use framework on mac
# want clean framework path, not unix compatibility path
if(APPLE)
    if(CMAKE_FIND_FRAMEWORK MATCHES "FIRST"
            OR CMAKE_FRAMEWORK_PATH MATCHES "ONLY"
            OR NOT CMAKE_FIND_FRAMEWORK)
        set(CMAKE_FIND_FRAMEWORK_save ${CMAKE_FIND_FRAMEWORK} CACHE STRING "" FORCE)
        set(CMAKE_FIND_FRAMEWORK "ONLY" CACHE STRING "" FORCE)
        find_library(KEA_LIBRARY KEA)
        if(KEA_LIBRARY)
            # FIND_PATH doesn't add "Headers" for a framework
            SET (KEA_INCLUDE_DIR ${KEA_LIBRARY}/Headers CACHE PATH "Path to a file.")
        endif(DAP_LIBRARY)
        set(CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_save} CACHE STRING "" FORCE)
    endif()
endif(APPLE)

# file locations
find_path(KEA_INCLUDE_DIR
        NAMES KEACommon.h kea-config.h
        HINTS "$ENV{LIB_DIR}/"
            "$ENV{LIB_DIR}/include/"
            "$ENV{KEA_ROOT}/"
            /usr/include/libkea
            /usr/local/include/libkea
            #mingw
            c:/msys/local/include/libkea
        DOC "Path to KEA headers"
        NO_DEFAULT_PATH)
find_path(KEA_INCLUDE_DIR kea-config.h)

find_library(KEA_LIBRARY
        NAMES libkea kea
        PATHS  "$ENV{LIB_DIR}/lib"
              /usr/lib
              /usr/local/lib
              #mingw
              c:/msys/local/lib
        DOC "Path to KEA library"
        NO_DEFAULT_PATH)
find_library(KEA_LIBRARY NAMES kea libkea)

if(KEA_INCLUDE_DIR AND KEA_LIBRARY)
    set(KEA_FOUND TRUE)
endif(KEA_INCLUDE_DIR AND KEA_LIBRARY)

if(KEA_FOUND)
   if(NOT KEA_FIND_QUIETLY)
      message(STATUS "Found KEA: ${KEA_LIBRARY}")
   endif(NOT KEA_FIND_QUIETLY)
else(KEA_FOUND)
   if(KEA_FIND_REQUIRED)
      message(FATAL_ERROR "Could not find KEA")
   endif(KEA_FIND_REQUIRED)
endif(KEA_FOUND)
