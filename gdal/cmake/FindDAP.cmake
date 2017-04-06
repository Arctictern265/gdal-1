# Find DAP - Data Access Protocol library
# ~~~~~~~~~
#
# Copyright (c) 2017, Hiroshi Miura <miurahr@linux.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# If it's found it sets DAP_FOUND to TRUE
# and following variables are set:
#    DAP_INCLUDE_DIR
#    DAP_LIBRARY
#    DAP_VERSION
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
        find_library(DAP_LIBRARY DAP)
        if(DAP_LIBRARY)
            # FIND_PATH doesn't add "Headers" for a framework
            SET (DAP_INCLUDE_DIR ${DAP_LIBRARY}/Headers CACHE PATH "Path to a file.")
        endif(DAP_LIBRARY)
        set(CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_save} CACHE STRING "" FORCE)
    endif()
endif(APPLE)


find_path(DAP_INCLUDE_DIR DapObj.h
        "$ENV{LIB_DIR}/"
        "$ENV{LIB_DIR}/include/"
        "$ENV{DAP_ROOT}/"
        /usr/include/libdap
        /usr/local/include/libdap
        #mingw
        c:/msys/local/include/libdap
        NO_DEFAULT_PATH
        )
find_path(DAP_INCLUDE_DIR DapObj.h)

find_library(DAP_LIBRARY NAMES dap libdap PATHS
  "$ENV{LIB_DIR}/lib"
  /usr/lib
  /usr/local/lib
  #mingw
  c:/msys/local/lib
  NO_DEFAULT_PATH
  )
find_library(DAP_LIBRARY NAMES dap libdap)

if(DAP_INCLUDE_DIR AND DAP_LIBRARY)
    set(DAP_FOUND TRUE)
    set(DAP_CONFIG_EXE dap-config)
    execute_process(COMMAND ${DAP_CONFIG_EXE} --version
            OUTPUT_VARIABLE DAP_VERSION
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif(DAP_INCLUDE_DIR AND DAP_LIBRARY)

if(DAP_FOUND)
   if(NOT DAP_FIND_QUIETLY)
      message(STATUS "Found DAP: ${DAP_LIBRARY}")
   endif(NOT DAP_FIND_QUIETLY)
else(DAP_FOUND)
   if(DAP_FIND_REQUIRED)
      message(FATAL_ERROR "Could not find DAP")
   endif(DAP_FIND_REQUIRED)
endif(DAP_FOUND)
