#!/bin/sh

set -e
export PATH=$PWD/cmake-3.9.2-Linux-x86_64/bin/:$PATH

mkdir cmake-gdal-debug
cd cmake-gdal-debug
cmake \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_CXX_COMPILER=clang++-4.0 \
  -DCMAKE_C_COMPILER=clang-4.0 \
  ../gdal

#cmake --build . --target docs >docs_log.txt 2>&1
#if cat docs_log.txt | grep -i warning | grep -v russian | grep -v brazilian | grep -v setlocale | grep -v 'has become obsolete' | grep -v 'To avoid this warning'; then echo 'Doxygen warnings found' && cat docs_log.txt && /bin/false; else echo 'No Doxygen warnings found'; fi
#cmake --build . --target man >man_log.txt 2>&1
#if cat man_log.txt | grep -i warning | grep -v setlocale | grep -v 'has become obsolete' | grep -v 'To avoid this warning'; then echo 'Doxygen warnings found' && cat docs_log.txt && /bin/false; else echo 'No Doxygen warnings found'; fi

cmake --build . -- USER_DEFS=-Werror -j3

sudo rm -f /usr/lib/libgdal.so*
cmake --build . --target install
sudo ldconfig

cd ../autotest/cpp && make -j3
exit 0
