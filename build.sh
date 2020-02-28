#!/bin/sh

set -e

apt-get -y update
apt-get -y upgrade
apt-get -y install wget git
unzip cesium-terrain-builder-master-quantized-mesh.zip
cd cesium-terrain-builder-master-quantized-mesh
mkdir build && cd build
cmake ..
make -j8
make -j8 install
ldconfig