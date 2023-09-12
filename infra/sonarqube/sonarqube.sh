#!/bin/bash
PWD=MyStrongPassword
PNAME=MyProject
PKEY=mykey
sudo docker pull sonarqube
sudo docker volume create sonarqube-conf
sudo docker volume create sonarqube-data
sudo docker volume create sonarqube-logs
sudo docker volume create sonarqube-extensions
sudo mkdir /sonarqube
sudo ln -s /var/lib/docker/volumes/sonarqube-conf/_data /sonarqube/conf
sudo ln -s /var/lib/docker/volumes/sonarqube-data/_data /sonarqube/data
sudo ln -s /var/lib/docker/volumes/sonarqube-logs/_data /sonarqube/logs
sudo ln -s /var/lib/docker/volumes/sonarqube-extensions/_data /sonarqube/extensions
sudo docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 -v sonarqube-conf:/opt/sonarqube/conf -v sonarqube-data:/opt/sonarqube/data -v sonarqube-logs:/opt/sonarqube/logs -v sonarqube-extensions:/opt/sonarqube/extensions sonarqube
sleep 20
curl -u admin:admin -X POST "http://localhost:9000/api/users/change_password?login=admin&previousPassword=admin&password=$PWD"
curl -X POST -u admin:2128506 "http://localhost:9000/api/projects/create?project=$PKEY&name=$PNAME"
