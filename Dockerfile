# -*- coding: utf-8 -*-
# Cesium Terrain Builder

FROM geodata/gdal:latest
MAINTAINER JIIN System <jiinwoojin@gmail.com>

RUN mkdir /app

WORKDIR /app

ADD ./build.sh ./
ADD ./cesium-terrain-builder-master-quantized-mesh.zip ./
RUN chmod 755 build.sh && ./build.sh