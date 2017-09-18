#!/bin/sh

set -e

sudo add-apt-repository -y ppa:miurahr/gta
# Pin to postgresql provided by ubuntugis.
echo "Package: *\nPin: release o=apt.postgresql.org,a=trusty-pgdg\nPin-Priority: -1\n" |sudo tee /etc/apt/preferences.d/ubuntugis-unstable-pin.pref @>&1 >/dev/null
sudo apt-get update -qq

# setup postgresql/postgis
sudo apt-get remove postgis libpq5 libpq-dev postgresql-9.2-postgis postgresql-9.2-postgis-2.2-scripts \
 postgresql-9.3-postgis postgresql-9.4-postgis postgresql-9.5-postgis postgresql-9.6-postgis \
 postgresql-9.2 postgresql-9.3 postgresql-9.4 postgresql-9.5 postgresql-9.6 libgdal1h
sudo apt-get install -y postgresql-9.3 postgresql-client-9.3 postgresql-9.3-postgis-2.2 postgresql-9.3-postgis-scripts \
 libgdal20 libpq-dev

# dependencies
sudo apt-get install -y --allow-unauthenticated python-numpy libpng12-dev libjpeg-dev libgif-dev liblzma-dev libgeos-dev \
 libcurl4-gnutls-dev libproj-dev libxml2-dev libexpat-dev libxerces-c-dev libnetcdf-dev netcdf-bin libpoppler-dev \
 libpoppler-private-dev libspatialite-dev gpsbabel swig libhdf4-alt-dev libhdf5-serial-dev libpodofo-dev poppler-utils \
 libfreexl-dev unixodbc-dev libwebp-dev libepsilon-dev liblcms2-2 libpcre3-dev libcrypto++-dev libdap-dev libfyba-dev \
 libkml-dev libmysqlclient-dev libogdi3.2-dev libcfitsio3-dev openjdk-8-jdk couchdb libarmadillo-dev \
 mesa-opencl-icd libclc-dev ocl-icd-opencl-dev librasterlite-dev libgta-dev \
 doxygen texlive-latex-base make cppcheck ccache g++ python-dev pyflakes \
 libsfcgal-dev fossil libgeotiff-dev libcharls-dev libopenjp2-7-dev libcairo2-dev

# cmake
wget https://cmake.org/files/v3.9/cmake-3.9.2-Linux-x86_64.tar.gz
tar xzf cmake-3.9.2-Linux-x86_64.tar.gz
export PATH=$PATH:$PWD/cmake-3.9.2-Linux-x86_64/bin/

wget http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci/FileGDB_API_1_2-64.tar.gz
wget http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci/MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44.tar.gz
wget http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci/install-libecwj2-ubuntu12.04-64bit.tar.gz
wget http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci/install-libkml-r864-64bit.tar.gz
wget http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci/install-openjpeg-2.0.0-ubuntu12.04-64bit.tar.gz
tar xzf MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44.tar.gz
sudo cp -r MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44/Raster_DSDK/include/* /usr/local/include
sudo cp -r MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44/Raster_DSDK/lib/* /usr/local/lib
sudo cp -r MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44/Lidar_DSDK/include/* /usr/local/include
sudo cp -r MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44/Lidar_DSDK/lib/* /usr/local/lib
tar xzf FileGDB_API_1_2-64.tar.gz
sudo cp -r FileGDB_API/include/* /usr/local/include
sudo cp -r FileGDB_API/lib/* /usr/local/lib
tar xzf install-libecwj2-ubuntu12.04-64bit.tar.gz
sudo cp -r install-libecwj2/include/* /usr/local/include
sudo cp -r install-libecwj2/lib/* /usr/local/lib
tar xzf install-libkml-r864-64bit.tar.gz
sudo cp -r install-libkml/include/* /usr/local/include
sudo cp -r install-libkml/lib/* /usr/local/lib
tar xzf install-openjpeg-2.0.0-ubuntu12.04-64bit.tar.gz
sudo cp -r install-openjpeg/include/* /usr/local/include
sudo cp -r install-openjpeg/lib/* /usr/local/lib
#tar xzf mongo-cxx-1.0.2-install-ubuntu12.04-64bit.tar.gz
wget https://bitbucket.org/chchrsc/kealib/get/c6d36f3db5e4.zip
unzip c6d36f3db5e4.zip
cd chchrsc-kealib-c6d36f3db5e4/trunk
cmake . -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DHDF5_INCLUDE_DIR=/usr/include -DHDF5_LIB_PATH=/usr/lib -DLIBKEA_WITH_GDAL=OFF
make -j4
sudo make install
cd ../..
sudo ldconfig
