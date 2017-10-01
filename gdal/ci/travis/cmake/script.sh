#!/bin/sh

set -e

# build root
cd cmake-gdal-debug

cd autotest/cpp
# quick test
ctest -I 1,2,3,4,5,6,7,8,9
# Compile and test vsipreload
#make vsipreload.so"

# Run ogr_fgdb test in isolation due to likely conflict with libxml2
cd ../ogr
python ogr_fgdb.py
rm ogr_fgdb.py
cd ../

# Run all the Python autotests
#python run_all.py"
ctest -I 1,2,3,4,5,6,7
