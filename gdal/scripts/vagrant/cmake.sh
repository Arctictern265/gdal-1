#!/bin/bash

# abort install if any errors occur and enable tracing
set -o errexit
set -o xtrace

wget -nv https://cmake.org/files/v3.9/cmake-3.9.2-Linux-x86_64.tar.gz
cat cmake-3.9.2-Linux-x86_64.tar.gz | (cd /opt; sudo tar xzf -)
sudo ln -s /opt/cmake-3.9.2-Linux-x86_64/bin/cmake /usr/bin/cmake
sudo ln -s /opt/cmake-3.9.2-Linux-x86_64/bin/ccmake /usr/bin/ccmake
sudo ln -s /opt/cmake-3.9.2-Linux-x86_64/bin/ctest /usr/bin/ctest
sudo ln -s /opt/cmake-3.9.2-Linux-x86_64/bin/cmake-gui /usr/bin/cmake-gui
