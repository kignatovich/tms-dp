#!/bin/bash
apt update
apt upgrade -y
pip3 install python-telegram-bot
mkdir -p /opt/infra
cp ./telegram_bot/tgbot.py /opt/infra
cp ./telegram_bot/tgbp.service /etc/systemd/system/
