#!/bin/bash
apt update
apt upgrade -y
pip3 install python-telegram-bot
mkdir -p /opt/infra
cp ./telegram_bot/tgbot.py /opt/infra
tail  /etc/systemd/system/tgbp.service << EOF
[Unit]
Description=My tg service
After=multi-user.target
 
[Service]
User=root
Group=root
Type=simple
Restart=always
ExecStart=/usr/bin/python3 /opt/infra/tgbot.py
 
[Install]
WantedBy=multi-user.target
EOF
