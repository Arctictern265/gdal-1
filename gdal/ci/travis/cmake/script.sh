#!/bin/sh

set -e

cd autotest/cpp
make quick_test
# Compile and test vsipreload
make vsipreload.so"

# Run ogr_fgdb test in isolation due to likely conflict with libxml2
cd ../ogr
python ogr_fgdb.py
rm ogr_fgdb.py
cd ../

# Run all the Python autotests
python run_all.py"
