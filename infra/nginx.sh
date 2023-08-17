#!/bin/bash
WORKDIR=/home/ubuntu/
ND=/etc/nginx
MAIL=admin@devsecops.by

rm $ND/sites-enabled/default
nginx_url=$(echo $(cat $WORKDIR/nginx_projeckt_url) | sed 's/\.$//')
jenkins_url=$(echo $(cat $WORKDIR/nginx_jenkins_url) | sed 's/\.$//')
sonarqube_url=$(echo $(cat $WORKDIR/nginx_sonarqube_url) | sed 's/\.$//')
prod_url=$(echo $(cat $WORKDIR/nginx_prod_url) | sed 's/\.$//')
dev_url=$(echo $(cat $WORKDIR/nginx_dev_url) | sed 's/\.$//')
pom_url=$(echo $(cat $WORKDIR/nginx_prometheus_url) | sed 's/\.$//')
graf_url=$(echo $(cat $WORKDIR/nginx_grafana_url) | sed 's/\.$//')
cad_url=$(echo $(cat $WORKDIR/nginx_cadvisor_url) | sed 's/\.$//')

mkdir -p /var/www/$nginx_url/html/
home_page=/var/www/$nginx_url/html

cp ./tms-dp/infra/nginx/example.conf $ND/conf.d/$nginx_url.conf && sed -i "s/EXAMPLE/$nginx_url/g" $ND/conf.d/$nginx_url.conf
cp ./tms-dp/infra/nginx/jenkins_example.conf $ND/conf.d/$jenkins_url.conf && sed -i "s/EXAMPLE/$jenkins_url/g" $ND/conf.d/$jenkins_url.conf
cp ./tms-dp/infra/nginx/sonaraube_example.conf $ND/conf.d/$sonarqube_url.conf && sed -i "s/EXAMPLE/$sonarqube_url/g" $ND/conf.d/$sonarqube_url.conf
cp ./tms-dp/infra/nginx/prod_example.conf $ND/conf.d/$prod_url.conf && sed -i "s/EXAMPLE/$prod_url/g" $ND/conf.d/$prod_url.conf
cp ./tms-dp/infra/nginx/dev_example.conf $ND/conf.d/$dev_url.conf && sed -i "s/EXAMPLE/$dev_url/g" $ND/conf.d/$dev_url.conf
cp ./tms-dp/infra/nginx/prometheus_examlpe.conf $ND/conf.d/$pom_url.conf && sed -i "s/EXAMPLE/$pom_url/g" $ND/conf.d/$pom_url.conf
cp ./tms-dp/infra/nginx/grafana_example.conf $ND/conf.d/$graf_url.conf && sed -i "s/EXAMPLE/$graf_url/g" $ND/conf.d/$graf_url.conf
cp ./tms-dp/infra/nginx/cadvisor_example.conf $ND/conf.d/$cad_url.conf && sed -i "s/EXAMPLE/$cad_url/g" $ND/conf.d/$cad_url.conf

cp ./tms-dp/infra/nginx/index.html $home_page 
sed -i "s/SQ_EXAMPLE/https:\/\/$sonarqube_url/g" $home_page/index.html
sed -i "s/JN_EXAMPLE/https:\/\/$jenkins_url/g" $home_page/index.html
sed -i "s/PROD_EXAMPLE/https:\/\/$prod_url/g" $home_page/index.html
sed -i "s/DEV_EXAMPLE/https:\/\/$dev_url/g" $home_page/index.html
sed -i "s/PROM_EXAMPLE/https:\/\/$dev_url/g" $home_page/index.html
sed -i "s/GRAF_EXAMPLE/https:\/\/$dev_url/g" $home_page/index.html
sed -i "s/CAD_EXAMPLE/https:\/\/$dev_url/g" $home_page/index.html


systemctl reload nginx
sudo certbot --nginx -d $nginx_url -d www.$nginx_url --non-interactive --agree-tos -m $MAIL
sudo certbot --nginx -d $jenkins_url -d www.$jenkins_url --non-interactive --agree-tos -m $MAIL
sudo certbot --nginx -d $sonarqube_url -d www.$sonarqube_url --non-interactive --agree-tos -m $MAIL
sudo certbot --nginx -d $dev_url -d www.$dev_url --non-interactive --agree-tos -m $MAIL
sudo certbot --nginx -d $prod_url -d www.$prod_url --non-interactive --agree-tos -m $MAIL
sudo certbot --nginx -d $pom_url -d www.$pom_url --non-interactive --agree-tos -m $MAIL
sudo certbot --nginx -d $graf_url -d www.$graf_url --non-interactive --agree-tos -m $MAIL
sudo certbot --nginx -d $cad_url -d www.$cad_url --non-interactive --agree-tos -m $MAIL

sed -i -e "s/0.0.0.0/$jenkins_url/g" ./tms-dp/infra/jenkins/jenkins-casc.yaml
