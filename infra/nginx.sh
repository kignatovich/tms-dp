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
mkdir -p /var/www/$nginx_url/html/
home_page=/var/www/$nginx_url/html

cp ./tms-dp/infra/nginx/example.conf $ND/conf.d/$nginx_url.conf && sed -i "s/EXAMPLE/$nginx_url/g" $ND/conf.d/$nginx_url.conf
cp ./tms-dp/infra/nginx/jenkins_example.conf $ND/conf.d/$jenkins_url.conf && sed -i "s/EXAMPLE/$jenkins_url/g" $ND/conf.d/$jenkins_url.conf
cp ./tms-dp/infra/nginx/sonaraube_example.conf $ND/conf.d/$sonarqube_url.conf && sed -i "s/EXAMPLE/$sonarqube_url/g" $ND/conf.d/$sonarqube_url.conf
cp ./tms-dp/infra/nginx/prod_example.conf $ND/conf.d/$prod_url.conf && sed -i "s/EXAMPLE/$prod_url/g" $ND/conf.d/$prod_url.conf
cp ./tms-dp/infra/nginx/dev_example.conf $ND/conf.d/$dev_url.conf && sed -i "s/EXAMPLE/$dev_url/g" $ND/conf.d/$dev_url.conf

cp ./tms-dp/infra/nginx/index.html $home_page 
sed -i "s/SQ_EXAMPLE/https:\/\/$sonarqube_url/g" $home_page/index.html
sed -i "s/JN_EXAMPLE/https:\/\/$jenkins_url/g" $home_page/index.html
sed -i "s/PROD_EXAMPLE/https:\/\/$prod_url/g" $home_page/index.html
sed -i "s/DEV_EXAMPLE/https:\/\/$dev_url/g" $home_page/index.html

systemctl reload nginx
sudo certbot --nginx -d $nginx_url -d www.$nginx_url --non-interactive --agree-tos -m $MAIL
sudo certbot --nginx -d $jenkins_url -d www.$jenkins_url --non-interactive --agree-tos -m $MAIL
sudo certbot --nginx -d $sonarqube_url -d www.$sonarqube_url --non-interactive --agree-tos -m $MAIL
sudo certbot --nginx -d $dev_url -d www.$dev_url --non-interactive --agree-tos -m $MAIL
sudo certbot --nginx -d $prod_url -d www.$prod_url --non-interactive --agree-tos -m $MAIL
