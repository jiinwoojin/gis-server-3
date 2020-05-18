# gis-server-3
mapnik + httpd (mod_tile)

# 실행 스크립트
docker run --rm -v /data/jiserver:/data/jiserver --name builder jiinwooin/terrain-builder ctb-tile -f Mesh -C -N -o {output dir} {input file}