#!/bin/bash
TRF=terraform_1.4.6_linux_amd64.zip
apt update
apt upgrade -y
apt install unzip python3-pip
wget https://hashicorp-releases.yandexcloud.net/terraform/1.4.6/$TRF
unzip $TRF -d ./
mv ./terraform /usr/local/bin/
pip3 install python-telegram-bot
sed -i "s/PATH_TO_FILE/$PWD/tms-dp/telegram_bot/tgbot.py/g" /$PWD/tms-dp/telegram_bot/tgbp.service
cp ./telegram_bot/tgbp.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable tgbp.service
sudo systemctl start tgbp.service
