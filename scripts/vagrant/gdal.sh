#!/bin/bash

# abort install if any errors occur and enable tracing
set -o errexit
set -o xtrace

NUMTHREADS=2
if [[ -f /sys/devices/system/cpu/online ]]; then
	# Calculates 1.5 times physical threads
	NUMTHREADS=$(( ( $(cut -f 2 -d '-' /sys/devices/system/cpu/online) + 1 ) * 15 / 10  ))
fi
#NUMTHREADS=1 # disable MP
export NUMTHREADS

mkdir cmake-gdal-debug
cd cmake-gdal-debug
cmake \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DGDAL_ENABLE_FRMT_RAW=ON \
  -DLANGUAGE_BINDING_PYTHON=ON \
  /vagrant

#  --with-ecw=/usr/local --with-mrsid=/usr/local --with-mrsid-lidar=/usr/local --with-fgdb=/usr/local
#./configure  --prefix=/usr --without-libtool --enable-debug --with-jpeg12 \
#            --with-python --with-poppler \
#            --with-spatialite --with-java --with-mdb \
#            --with-jvm-lib-add-rpath --with-epsilon --with-gta \
#           --with-sosi --with-rasterlite --with-hdf5 \
#            --with-mysql --with-liblzma --with-webp --with-libkml \
#            --with-openjpeg=/usr/local --with-armadillo

cmake --build . --target gdal23 -- -j $NUMTHREADS
cmake --build . --target test_ogrsf -- -j $NUMTHREADS

# A previous version of GDAL has been installed by PostGIS
sudo rm -f /usr/lib/libgdal.so*
sudo cmake --build . --target install
sudo ldconfig

#cd swig/perl
#make veryclean
#make
#make test
#cd ../..

#cd swig/java
#JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 make
#make test
#cd ../..

#cd swig/csharp
#make
#make test
#cd ../..
