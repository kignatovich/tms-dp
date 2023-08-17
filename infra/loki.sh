#!/bin/bash
docker run --name loki -d --restart always -v $(pwd)/tms-dp/infra/loki:/mnt/config -p 3100:3100 grafana/loki:2.8.0 -config.file=/mnt/config/loki-config.yaml
sleep 5
docker run --name promtail -d --restart always -v $(pwd)/tms-dp/infra/loki:/mnt/config -v /var/log:/var/log --link loki grafana/promtail:2.8.0 -config.file=/mnt/config/promtail-config.yaml
echo  "Loki is running!!!!!"
