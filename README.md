### ### В процессе написания

# Настройка сервисной машины(она отвечает за запуск разворачивания инфраструктуры).
В качестве инфрастуктуры используется Yandex Cloud.
Перед запуском развертывания, нужно установить CLI от яндекса, и авторизоваться в нем.

Установка CLI
```shell
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```

[Подробнее](https://cloud.yandex.ru/docs/cli/operations/install-cli)

[Настройка аутентификации](https://cloud.yandex.ru/docs/cli/operations/authentication/user)

После выполнения всех действий и авторизации, можно выполнить команду(команда выводит список публичных образов, можно любую другую):
```shell
yc compute image list --folder-id standard-images
```

Для установки telegram бота, нужно сделать следующие команды:
```shell
git clone git@github.com:kignatovich/tms-dp.git
chmode +x ./telegram_bot/instll_bot.sh
./telegram_bot/install_bot.sh
```
## Установка terraform
```shell
wget https://hashicorp-releases.yandexcloud.net/terraform/1.4.6/terraform_1.4.6_linux_amd64.zip
unzip terraform_1.4.6_linux_amd64.zip
mv terraform /usr/local/bin/
```
 
