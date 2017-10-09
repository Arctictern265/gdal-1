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

set(LIB_NAME "cpl")
project ("lib${LIB_NAME}")

include (CheckFunctionExists)
include (CheckIncludeFile)
include (CheckIncludeFiles)
include (CheckLibraryExists)
include (CheckSymbolExists)
include (CheckCXXSymbolExists)
include (CheckTypeSize)
include (TestBigEndian)
include (CheckCSourceCompiles)
include (CheckCXXSourceCompiles)
include (GdalUtils)

if(MSVC)

    include_directories(${GIS_SDK_DIR}/include)
    link_directories(${GIS_SDK_DIR}/lib)

    check_function_exists("atoll"   HAVE_ATOLL)
    check_function_exists("strtof"  HAVE_DECL_STRTOF)
    check_function_exists("fopen64" HAVE_FOPEN64)
    check_function_exists("stat64"  HAVE_STAT64)

    if(NOT CPL_DISABLE_STDCALL)
        set(CPL_STDCALL __stdcall)
    endif()

    set(HAVE_DOPRNT 0)
    set(HAVE_VPRINTF 1)
    set(HAVE_VSNPRINTF 1)
    set(HAVE_SNPRINTF 1)
    if(_MSC_VER and _MSC_VER SMALLER 1500)
        set(vsnprintf _vsnprintf)
    endif()
    set(snprintf _snprintf)

    set(HAVE_GETCWD 1)
    if(NOT defined(getcwd))
        set(getcwd _getcwd)
    endif()

    if(NOT STDC_HEADERS)
        set(STDC_HEADERS 1)
    endif()

    set(HAVE_ASSERT_H 1)
    set(HAVE_FCNTL_H  1)
    set(HAVE_UNISTD_H 0)
    set(HAVE_STDINT_H 0)
    set(HAVE_SYS_TYPES_H 1)
    set(HAVE_LIBDL    0)
    set(HAVE_LOCALE_H 1)
    set(HAVE_FLOAT_H  1)
    set(HAVE_ERRNO_H  1)
    set(HAVE_SEARCH_H 1)
    set(HAVE_DIRECT_H 1)

    set(HAVE_LOCALTIME_R 0)
    set(HAVE_DLFCN_H     0)
    set(HAVE_DBMALLOC_H  0)
    set(HAVE_LIBDBMALLOC 0)
    set(WORDS_BIGENDIAN  0)
    set(ICONV_CPP_CONST  0)
    set(SIZEOF_INT  4)
    set(SIZEOF_LONG 4)
    set(SIZEOF_UNSIGNED_LONG 4)
    if(_WIN64)
        set(SIZEOF_VOIDP 8)
    else()
        set(SIZEOF_VOIDP 4)
    endif()
    set(HOST_FILLORDER FILLORDER_LSB2MSB)
    set(HAVE_IEEEFP 1)

    if(NOT __cplusplus)
        if(NOT inline)
            set(inline __inline)
        endif()
    endif()

    set(lfind _lfind)

    if(_MSC_VER and _MSC_VER SMALLER 1310)
        set(VSI_STAT64 _stat)
        set(VSI_STAT64_T _stat)
        else()
        set(VSI_STAT64 _stat64)
        set(VSI_STAT64_T __stat64)
    endif()

    if(_MSC_VER and _MSC_VER EQUAL_SMALLER 1280)
        #    typedef int intptr_t;
    endif()

else(MSVC)

    find_package(Threads)

    option(CPL_MULTIPROC_PTHREAD "Set to ON if you want to use pthreads based multiprocessing support." ON)
    mark_as_advanced(CPL_MULTIPROC_PTHREAD)

    if(CPL_MULTIPROC_PTHREAD)
        check_function_exists(pthread_mutex_init HAS_PTHREAD_MUTEXES)
        gdal_add_definitions(HAS_PTHREAD_MUTEXES)
        check_symbol_exists(pthread_mutex_recursive pthread.h HAVE_PTHREAD_MUTEX_RECURSIVE)
        gdal_add_definitions(HAVE_PTHREAD_MUTEX_RECURSIVE)
        check_symbol_exists(pthread_mutex_adaptive_np pthread.h HAVE_PTHREAD_MUTEX_ADAPTIVE_NP)
        gdal_add_definitions(HAVE_PTHREAD_MUTEX_ADAPTIVE_NP)
    endif()

    check_include_files( assert.h HAVE_ASSERT_H)
    gdal_add_definitions(HAVE_ASSERT_H)

    check_function_exists("atoll" HAVE_ATOLL)

    check_include_files( csf.h HAVE_CSF_H)  
    gdal_add_definitions(HAVE_CSF_H)

    check_include_files( dbmalloc.h HAVE_DBMALLOC_H) 
    gdal_add_definitions(HAVE_DBMALLOC_H)

    check_function_exists("strtof" HAVE_DECL_STRTOF)    

    check_include_files( direct.h HAVE_DIRECT_H)    
    gdal_add_definitions(HAVE_DIRECT_H)

    check_function_exists("fopen64" HAVE_FOPEN64)
    check_function_exists("stat64" HAVE_STAT64)

    if("${HAVE_FOPEN64}" STREQUAL "1" AND "${HAVE_STAT64}" STREQUAL "1")
	set(UNIX_STDIO_64 TRUE)
        set(VSI_LARGE_API_SUPPORTED TRUE)  
        set(VSI_FSEEK64 "fseeko64")
        set(VSI_FTELL64 "ftello64")
        set(VSI_FOPEN64 "fopen64")
        set(VSI_STAT64 "stat64")
        set(VSI_TRANCATE64 ftruncate64)
    else()
	set(UNIX_STDIO_64 FALSE)
        set(VSI_LARGE_API_SUPPORTED FALSE)  
        set(VSI_FSEEK64 "fseek")
        set(VSI_FTELL64 "ftell")
        set(VSI_FOPEN64 "fopen")
        set(VSI_STAT64 "stat")
        set(VSI_TRANCATE64 "ftruncate")
    endif()

    set(VSI_STAT64_T ${VSI_STAT64})    

    check_function_exists("vprintf" HAVE_VPRINTF)
    if(NOT ${HAVE_VPRINTF})
        check_function_exists("_doprnt" HAVE_DOPRNT)
    endif(NOT ${HAVE_VPRINTF})
		
    check_include_files( dlfcn.h HAVE_DLFCN_H) 
    gdal_add_definitions(HAVE_DLFCN_H)
	
    check_include_files( errno.h HAVE_ERRNO_H)
    gdal_add_definitions(HAVE_ERRNO_H)

    check_include_files( fcntl.h HAVE_FCNTL_H) 
    gdal_add_definitions(HAVE_FCNTL_H)

    check_include_files( float.h HAVE_FLOAT_H) 
    gdal_add_definitions(HAVE_FLOAT_H)

    check_function_exists("getcwd" HAVE_GETCWD)
    check_function_exists("lstat" HAVE_LSTAT)
    check_function_exists("posix_memalign" HAVE_POSIX_MEMALIGN)

    check_library_exists(c "" "" HAVE_LIBC)
    check_type_size("int16" HAVE_INT16)
    check_type_size("int32" HAVE_INT32)
    check_type_size("int8"  HAVE_INT8)
	
    check_include_files(ieeefp.h HAVE_IEEEFP_H)
    set(HAVE_IEEEFP TRUE)
	
    check_include_files(inttypes.h HAVE_INTTYPES_H)
    gdal_add_definitions(HAVE_INTTYPES_H)

    check_include_files(jpeglib.h HAVE_JPEGLIB_H)
    check_include_files( png.h HAVE_PNG_H)
	
    check_type_size ("int"           SIZEOF_INT         )
    check_type_size ("uint32_t"      HAVE_UINT32_T      )
    check_type_size ("int64_t"       HAVE_INT64_T     )
    check_type_size ("float"         SIZEOF_FLOAT       )
    check_type_size ("double"        SIZEOF_DOUBLE      )
    check_type_size ("long"          SIZEOF_LONG        )
    check_type_size ("unsigned long" SIZEOF_UNSIGNED_LONG)
    check_type_size ("long long"     SIZEOF_LONG_LONG   )
	check_type_size ("long long"     HAVE_LONG_LONG)
    check_type_size ("short"         SIZEOF_SHORT       )
    check_type_size ("off_t"         SIZEOF_OFF_T       )
    check_type_size ("pid_t"         SIZEOF_PID_T       )
    check_type_size ("size_t"        SIZEOF_SIZE_T      )
    check_type_size ("socklen_t"     SIZEOF_SOCKLEN_T    )
    check_type_size ("sig_atomic_t"  SIZEOF_SIG_ATOMIC_T )
    check_type_size ("void *"        SIZEOF_VOID_P       )
    check_type_size ("uintptr_t"     SIZEOF_UINTPTR_T    )
    check_type_size ("_Bool"         HAVE__BOOL          )
    check_type_size ("intptr_t"      SIZEOF_INTPTR_T     )

    include(FindInt128)
    if(INT128_FOUND)
        gdal_add_definitions(HAVE_UINT128_T)
    endif()

#    test_big_endian(WORDS_BIGENDIAN)
    if (WORDS_BIGENDIAN)
        set (HOST_FILLORDER FILLORDER_MSB2LSB)
    else (WORDS_BIGENDIAN)
        set (HOST_FILLORDER FILLORDER_LSB2MSB)
    endif (WORDS_BIGENDIAN)

    check_library_exists(m matherr "" HAVE_LIBM)
    check_library_exists(dl dlopen "" HAVE_LIBDL)
    #check_library_exists(rt "" "" HAVE_LIBRT) need some working checks
    set(HAVE_LIBRT 1)

    check_include_files( limits.h HAVE_LIMITS_H)
    gdal_add_definitions(HAVE_LIMITS_H)

    check_include_files( locale.h HAVE_LOCALE_H)
    gdal_add_definitions(DHAVE_LOCALE_H)

    check_include_files( memory.h HAVE_MEMORY_H)
    gdal_add_definitions(HAVE_MEMORY_H)
	
    check_function_exists("snprintf" HAVE_SNPRINTF)
    check_include_files( stdint.h HAVE_STDINT_H)
    gdal_add_definitions(HAVE_STDINT_H)

    check_include_files( stddef.h HAVE_STDDEF_H)
    gdal_add_definitions(HAVE_STDDEF_H)

    check_include_files( stdlib.h HAVE_STDLIB_H)
    gdal_add_definitions(HAVE_STDLIB_H)

    check_include_files( strings.h HAVE_STRINGS_H)
    gdal_add_definitions(HAVE_STRINGS_H)

    check_include_files( string.h HAVE_STRING_H)
    gdal_add_definitions(HAVE_STRING_H)

    check_function_exists("strtof" HAVE_STRTOF)

    check_include_file(sys/stat.h HAVE_SYS_STAT_H)
    gdal_add_definitions(HAVE_SYS_STAT_H)

    check_include_file(sys/types.h HAVE_SYS_TYPES_H)
    gdal_add_definitions(HAVE_SYS_TYPES_H)

    check_include_file(unistd.h HAVE_UNISTD_H)
    gdal_add_definitions(HAVE_UNISTD_H)

    check_include_file(values.h HAVE_VALUES_H)
    gdal_add_definitions(HAVE_VALUES_H)

    check_cxx_symbol_exists(_SC_PHYS_PAGES unistd.h HAVE_SC_PHYS_PAGES)

    check_function_exists("vprintf" HAVE_VPRINTF)
    check_function_exists("vsnprintf" HAVE_VSNPRINTF)
    check_function_exists("readlink" HAVE_READLINK)

    CHECK_C_SOURCE_COMPILES("#define _GNU_SOURCE\n#include <sys/mman.h>\n
            void main(void) {return (mremap(0,0,0,0,0));}"  HAVE_5ARGS_MREMAP)

    CHECK_C_SOURCE_COMPILES("int main(int argc, char** argv) {
            int i; __sync_add_and_fetch(&i, 1); __sync_sub_and_fetch(&i, 1);
            __sync_bool_compare_and_swap(&i, 0, 1);
            return 0; } " HAVE_GCC_ATOMIC_BUILTINS)

    OPTION(USE_GCC_VISIBILITY_FLAG "Define to 1 if you want to use the -fvisibility GCC flag" OFF)

    if(MACOSX_BUNDLE)
        set(CPL_CONFIG_EXTRAS "#include \"cpl_config_extras.h\"" INTERNAL)
    endif(MACOSX_BUNDLE)

    if (HAVE_STDDEF_H AND HAVE_STDINT_H)
      set(STDC_HEADERS TRUE)
    endif (HAVE_STDDEF_H AND HAVE_STDINT_H)

endif(MSVC)


include_directories(${GDAL_ROOT_BINARY_DIR}/port)
set(LIB_HHEADERS
        #cpl_config.h
        cplkeywordparser.h
        cpl_atomic_ops.h
        cpl_config_extras.h
        cpl_conv.h
        cpl_cpu_features.h
        cpl_csv.h
        cpl_error.h
        cpl_hash_set.h
        cpl_http.h
        cpl_list.h
        cpl_minixml.h
        cpl_multiproc.h
        cpl_port.h
        cpl_quad_tree.h
        cpl_safemaths.hpp
        cpl_sha1.h
        cpl_sha256.h
        cpl_string.h
        cpl_time.h
        cpl_vsi.h
        cpl_vsi_error.h
        cpl_vsi_virtual.h
        cpl_virtualmem.h
        gdal_csv.h
        cpl_spawn.h
        cpl_progress.h
)

set(LIB_CSOURCES
        cpl_conv.cpp
        cpl_error.cpp
        cpl_string.cpp
        cplgetsymbol.cpp
        cplstringlist.cpp
        cpl_strtod.cpp
        cpl_path.cpp
        cpl_csv.cpp
        cpl_findfile.cpp
        cpl_minixml.cpp
        cpl_multiproc.cpp
        cpl_list.cpp
        cpl_getexecpath.cpp
        cplstring.cpp
        #cpl_vsil_win32.cpp
        cpl_vsisimple.cpp
        cpl_vsil.cpp
        cpl_vsi_mem.cpp
        #cpl_vsil_unix_stdio_64.cpp
        cpl_http.cpp
        cpl_hash_set.cpp
        cplkeywordparser.cpp
        cpl_recode.cpp
        cpl_recode_iconv.cpp
        cpl_recode_stub.cpp
        cpl_quad_tree.cpp
        cpl_atomic_ops.cpp
        cpl_vsil_subfile.cpp
        cpl_time.cpp
        cpl_vsil_stdout.cpp
        cpl_vsil_sparsefile.cpp
        cpl_vsil_abstract_archive.cpp
        cpl_vsil_tar.cpp
        cpl_vsil_stdin.cpp
        cpl_vsil_buffered_reader.cpp
        cpl_base64.cpp
        cpl_vsil_curl.cpp
        cpl_vsil_curl_streaming.cpp
        cpl_vsil_cache.cpp
        cpl_xml_validate.cpp
        cpl_spawn.cpp
        cpl_google_oauth2.cpp
        cpl_progress.cpp
        cpl_virtualmem.cpp
        cpl_worker_thread_pool.cpp
        cpl_vsil_crypt.cpp
        cpl_sha1.cpp
        cpl_sha256.cpp
        cpl_aws.cpp
        cpl_vsi_error.cpp
        cpl_cpu_features.cpp
        cpl_google_cloud.cpp

)

if(WIN32)
    set(LIB_CSOURCES ${LIB_CSOURCES} cpl_vsil_win32.cpp)
else(WIN32)
    set(LIB_CSOURCES ${LIB_CSOURCES} cpl_vsil_unix_stdio_64.cpp)
endif(WIN32)

#check zip and internal zip
option(GDAL_USE_LIBZ "Set ON to use libz" ON)
if(GDAL_USE_LIBZ)
	option(GDAL_USE_LIBZ_INTERNAL "Set ON to use internal libz" OFF)
	add_definitions(-DHAVE_LIBZ -DZIP_SUPPORT)
	set(LIB_HHEADERS ${LIB_HHEADERS}
		cpl_minizip_ioapi.h
		cpl_minizip_unzip.h
		cpl_minizip_zip.h
	)
	
	set(LIB_CSOURCES ${LIB_CSOURCES}
		cpl_vsil_gzip.cpp 
		cpl_minizip_ioapi.cpp 
		cpl_minizip_unzip.cpp 
		cpl_minizip_zip.cpp 
	)	
	if(GDAL_USE_LIBZ_INTERNAL)
		include_directories(${GDAL_ROOT_SOURCE_DIR}/frmts/zlib)
		add_subdirectory(${GDAL_ROOT_SOURCE_DIR}/frmts/zlib ${GDAL_ROOT_BINARY_DIR}/frmts/zlib)
	else(GDAL_USE_LIBZ_INTERNAL)
		find_package(ZLIB REQUIRED)
		if(ZLIB_FOUND)
			include_directories(${ZLIB_INCLUDE_DIRS})
			add_definitions(-DHAVE_ZLIB_H -DHAVE_ZLIB)
			if(MSVC)
				add_definitions(-DZLIB_DLL)
			endif(MSVC)
		else(ZLIB_FOUND)	
			MESSAGE(FATAL_ERROR "Could not find ZLIB")
		endif(ZLIB_FOUND)		
	endif(GDAL_USE_LIBZ_INTERNAL)
endif(GDAL_USE_LIBZ)	

#check curl
option(GDAL_USE_CURL "Set ON to use libcurl" ON)
if(GDAL_USE_CURL)
	find_package(CURL REQUIRED)
	if(CURL_FOUND)
		include_directories(${CURL_INCLUDE_DIRS})
		add_definitions(-DHAVE_CURL)
		
		set(LIB_HHEADERS ${LIB_HHEADERS}
			cpl_vsil_curl_priv.h
		)
	
		set(LIB_CSOURCES ${LIB_CSOURCES}
			cpl_vsil_curl.cpp
			cpl_vsil_curl_streaming.cpp
		)
	endif(CURL_FOUND)
endif(GDAL_USE_CURL)

#check Iconv
option(GDAL_USE_ICONV "Set ON to use libiconv" OFF)
if(GDAL_USE_ICONV)
    find_package(Iconv REQUIRED)
    set(HAVE_ICONV ${ICONV_FOUND})
    set(GDAL_HAVE_ICONV ${ICONV_FOUND} PARENT_SCOPE)
    if(ICONV_SECOND_ARGUMENT_IS_CONST)
      set(ICONV_CONST "const")
    endif(ICONV_SECOND_ARGUMENT_IS_CONST)
    include_directories(${ICONV_INCLUDE_DIR})
    add_definitions(-DHAVE_ICONV -DLIBICONV_PLUG)
else() # check libc built-in iconv
    check_include_files( iconv.h HAVE_ICONV_H)
    set(HAVE_ICONV ${HAVE_ICONV_H})
    if(HAVE_ICONV)
        gdal_add_definitions(HAVE_ICONV)
        add_definitions(-DHAVE_ICONV)
    endif()
endif()

#check odbc
option(GDAL_USE_ODBC "Set ON to use odbc" OFF)
if(GDAL_USE_ODBC)
	set(LIB_HHEADERS ${LIB_HHEADERS}
		cpl_odbc.h
	)
	
	set(LIB_CSOURCES ${LIB_CSOURCES}
		cpl_odbc.cpp  
	)
endif(GDAL_USE_ODBC)

option(GDAL_USE_XMLREFORMAT "Set ON to use xmlreformat" OFF)
if(GDAL_USE_XMLREFORMAT)
		set(LIB_CSOURCES ${LIB_CSOURCES}
			xmlreformat.cpp  
		)
endif(GDAL_USE_XMLREFORMAT)

set(GDAL_TARGET_OBJECTS ${GDAL_TARGET_OBJECTS} $<TARGET_OBJECTS:${LIB_NAME}> PARENT_SCOPE)
add_library(${LIB_NAME} OBJECT ${LIB_HHEADERS} ${LIB_CSOURCES})

# Thread configuration
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} pthread)

# Generate cpl_config.h
configure_file(${CMAKE_MODULE_PATH}/cpl_config.h.cmake ${GDAL_ROOT_BINARY_DIR}/port/cpl_config.h @ONLY)
message(STATUS "cpl_config.h is configured")

if(ZLIB_FOUND)
	set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${ZLIB_LIBRARIES})
endif(ZLIB_FOUND)

if(CURL_FOUND)
	set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${CURL_LIBRARIES})
endif(CURL_FOUND)

if(ICONV_FOUND)
	set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} ${ICONV_LIBRARIES})
endif(ICONV_FOUND)

set(GDAL_TARGET_LINK_LIB ${GDAL_TARGET_LINK_LIB} PARENT_SCOPE)

install(FILES ${LIB_HHEADERS} DESTINATION include/gdal)
#install(DIRECTORY ${GDAL_ROOT_SOURCE_DIR}/port DESTINATION include/gdal FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp")
