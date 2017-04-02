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

cd /vagrant
#  --with-ecw=/usr/local --with-mrsid=/usr/local --with-mrsid-lidar=/usr/local --with-fgdb=/usr/local
./configure  --prefix=/usr --without-libtool --enable-debug --with-jpeg12 \
            --with-python --with-poppler \
            --with-podofo --with-spatialite --with-java --with-mdb \
            --with-jvm-lib-add-rpath --with-epsilon --with-gta \
            --with-sosi --with-rasterlite2 --with-hdf5 \
            --with-mysql --with-liblzma --with-webp --with-libkml \
            --with-openjpeg=/usr/local --with-armadillo

make clean >/dev/null
make -j $NUMTHREADS
cd apps
make test_ogrsf
cd ..

# A previous version of GDAL has been installed by PostGIS
sudo rm -f /usr/lib/libgdal.so*
sudo make install
sudo ldconfig

cd swig/perl
make veryclean
make
make test
cd ../..

cd swig/java
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 make
make test
cd ../..

cd swig/csharp
make
make test
cd ../..
