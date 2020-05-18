# gis-server-3
mapnik + httpd (mod_tile)

# 실행 스크립트
docker run -it -p 11190:80 -v /etc/localtime:/etc/localtime:ro -v /data/jiapp:/data/jiapp --name gis-server-3 jiinwoojin/gis-server-3

docker exec --user 1002:1002 gis-server-3 renderd -f -c /data/jiapp/data_dir/conf/renderd.conf &> /data/jiapp/data_dir/logs/renderd.log