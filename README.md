# Настройка сервисной машины которая управляет инфраструктурой.
В качестве инфрастуктуры используется Yandex Cloud.
Перед запуском развертывания, нужно установить CLI от яндекса, и авторизоваться в нем.

Установка CLI
```shell
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```
Подробнее.
https://cloud.yandex.ru/docs/cli/operations/install-cli
Настройка аутентификации
https://cloud.yandex.ru/docs/cli/operations/authentication/user

После выполнения авторизации, можно выполнить команду(команда выводит список публичных образов, можно любую другую):
```shell
yc compute image list --folder-id standard-images
```

Для установки telegram бота, нужно сделать следующие команды:
```shell
git clone
chmode +x ./instll_bot.sh
./install_bot.sh
```
