#!/bin/bash
TRF=terraform_1.4.6_linux_amd64.zip
apt update
apt upgrade -y
apt install unzip python3-pip
wget https://hashicorp-releases.yandexcloud.net/terraform/1.4.6/$TRF
unzip $TRF -d ./
mv ./terraform /usr/local/bin/
pip3 install python-telegram-bot
mkdir -p /opt/infra/sonarqube
cp ./telegram_bot/tgbot.py /opt/infra/
cp ./telegram_bot/tgbp.service /etc/systemd/system/
cp ./infra/sonarqube/docker-compose.yml /opt/infra/sonarqube
sudo systemctl daemon-reload
sudo systemctl enable tgbp.service
sudo systemctl start tgbp.service
