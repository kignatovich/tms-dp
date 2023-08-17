#!/bin/bash
cd loki/
docker run --name loki -d -v $(pwd):/mnt/config -p 3100:3100 grafana/loki:2.8.0 -config.file=/mnt/config/loki-config.yaml
sleep 5
docker run --name promtail -d -v $(pwd):/mnt/config -v /var/log:/var/log --link loki grafana/promtail:2.8.0 -config.file=/mnt/config/promtail-config.yaml
echo  "Loki is running!!!!!"
