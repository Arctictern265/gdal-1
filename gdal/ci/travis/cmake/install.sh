#!/bin/sh

set -e
export PATH=$PWD/cmake-3.9.2-Linux-x86_64/bin/:$PATH

mkdir cmake-gdal-debug
cd cmake-gdal-debug
LDFLAGS='-lstdc++' cmake ../gdal

# XXX: temporary off cppcheck.
#cd ../gdal && scripts/cppcheck.sh

cmake --target docs >docs_log.txt 2>&1
if cat docs_log.txt | grep -i warning | grep -v russian | grep -v brazilian | grep -v setlocale | grep -v 'has become obsolete' | grep -v 'To avoid this warning'; then echo 'Doxygen warnings found' && cat docs_log.txt && /bin/false; else echo 'No Doxygen warnings found'; fi
cmake --target man >man_log.txt 2>&1
if cat man_log.txt | grep -i warning | grep -v setlocale | grep -v 'has become obsolete' | grep -v 'To avoid this warning'; then echo 'Doxygen warnings found' && cat docs_log.txt && /bin/false; else echo 'No Doxygen warnings found'; fi
cmake -- USER_DEFS=-Werror -j3

cmake --build $PWD/cmake-gdal-debug/apps --target test_ogrsf -- USER_DEFS=-Werror -j3

sudo rm -f /usr/lib/libgdal.so*
cmake --target install
sudo ldconfig

cd ../autotest/cpp && make -j3
exit 0
