#!/bin/sh

set -e

sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
sudo add-apt-repository -y ppa:miurahr/gta
# Pin to postgresql provided by ubuntugis.
echo "Package: *\nPin: release o=apt.postgresql.org,a=trusty-pgdg\nPin-Priority: -1\n" |sudo tee /etc/apt/preferences.d/ubuntugis-unstable-pin.pref @>&1 >/dev/null
sudo apt-get update
sudo apt-get install -y postgresql-9.3 postgresql-client-9.3 postgresql-9.3-postgis-2.2 postgresql-9.3-postgis-scripts libgdal20 libpq-dev
sudo apt-get install -y --allow-unauthenticated python-numpy libpng12-dev libjpeg-dev libgif-dev liblzma-dev libgeos-dev libcurl4-gnutls-dev libproj-dev libxml2-dev libexpat-dev libxerces-c-dev libnetcdf-dev netcdf-bin libpoppler-dev libpoppler-private-dev libspatialite-dev gpsbabel swig libhdf4-alt-dev libhdf5-serial-dev libpodofo-dev poppler-utils libfreexl-dev unixodbc-dev libwebp-dev libepsilon-dev liblcms2-2 libpcre3-dev libcrypto++-dev libdap-dev libfyba-dev libkml-dev libmysqlclient-dev libogdi3.2-dev libcfitsio-dev openjdk-8-jdk couchdb libarmadillo-dev
sudo apt-get install -y mesa-opencl-icd libclc-dev ocl-icd-opencl-dev
sudo apt-get install -y librasterlite-dev libgta-dev
sudo apt-get install -y doxygen texlive-latex-base
sudo apt-get install -y make
sudo apt-get install -y python-dev
sudo apt-get install -y g++
sudo apt-get install -y libsfcgal-dev
sudo apt-get install -y fossil libgeotiff-dev libcharls-dev libopenjp2-7-dev libcairo2-dev

wget https://cmake.org/files/v3.9/cmake-3.9.2-Linux-x86_64.tar.gz
tar xzf cmake-3.9.2-Linux-x86_64.tar.gz
#should add "export PATH=$PATH:$PWD/cmake-3.9.2-Linux-x86_64/bin/"

wget https://github.com/Esri/file-geodatabase-api/raw/master/FileGDB_API_1.5/FileGDB_API_1_5_64gcc51.tar.gz
tar xzf FileGDB_API_1_5_64gcc51.tar.gz
echo $PWD/FileGDB_API-64gcc51/lib/ | sudo tee /etc/ld.so.conf.d/gdal_custom_dependencies.conf
sudo ldconfig

sudo apt-get install -y pyflakes3
sudo sh -c "cd $PWD && pyflakes3 autotest"
sudo sh -c "cd $PWD && pyflakes3 gdal/swig/python/scripts"
sudo sh -c "cd $PWD && pyflakes3 gdal/swig/python/samples"

sudo apt-get install -y cppcheck bash
