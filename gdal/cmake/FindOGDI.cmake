# Find OGDI - Open Geographic Datastore Interface Library
# ~~~~~~~~~
#
# Copyright (c) 2017, Hiroshi Miura <miurahr@linux.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# If it's found it sets DAP_FOUND to TRUE
# and following variables are set:
#    OGDI_INCLUDE_DIR
#    OGDI_LIBRARY
#    OGDI_VERSION
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
        find_library(OGDI_LIBRARY DAP)
        if(OGDI_LIBRARY)
            # FIND_PATH doesn't add "Headers" for a framework
            SET (OGDI_INCLUDE_DIR ${DAP_LIBRARY}/Headers CACHE PATH "Path to a file.")
        endif(OGDI_LIBRARY)
        set(CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_save} CACHE STRING "" FORCE)
    endif()
endif(APPLE)


find_path(OGDI_INCLUDE_DIR ecs.h
        "$ENV{LIB_DIR}/"
        "$ENV{LIB_DIR}/include/"
        "$ENV{DAP_ROOT}/"
        /usr/include/ogdi
        /usr/local/include/ogdi
        #mingw
        c:/msys/local/include/ogdi
        NO_DEFAULT_PATH
        )
find_path(OGDI_INCLUDE_DIR ecs.h)

find_library(OGDI_LIBRARY NAMES ogdi libogdi vpf libvpf PATHS
  "$ENV{LIB_DIR}/lib"
  /usr/lib
  /usr/local/lib
  #mingw
  c:/msys/local/lib
  NO_DEFAULT_PATH
  )
find_library(OGDI_LIBRARY NAMES ogdi libogdi vpf libvpf)

if(OGDI_INCLUDE_DIR AND OGDI_LIBRARY)
    set(OGDI_FOUND TRUE)
    set(OGDI_CONFIG_EXE ogdi-config)
    execute_process(COMMAND ${OGDI_CONFIG_EXE} --version
            OUTPUT_VARIABLE OGDI_VERSION
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif(OGDI_INCLUDE_DIR AND OGDI_LIBRARY)

if(OGDI_FOUND)
   if(NOT OGDI_FIND_QUIETLY)
      message(STATUS "Found OGDI Library: ${OGDI_LIBRARY}")
   endif(NOT OGDI_FIND_QUIETLY)
else(OGDI_FOUND)
   if(OGDI_FIND_REQUIRED)
      message(FATAL_ERROR "Could not find OGDI Library.")
   endif(OGDI_FIND_REQUIRED)
endif(OGDI_FOUND)
