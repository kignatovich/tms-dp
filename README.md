## В проекте 2 ветки: main(все для создания среды для разработки: ci\cd, мониторинг и тд) и terraform_bot_bran(телеграмм бот и терраформ)

# Настройка сервисной машины(она отвечает за запуск разворачивания инфраструктуры).
В качестве инфрастуктуры используется Yandex Cloud.
Для начала работы с YC нужно в нем зарегистрироваться, создать организацию и каталог.

## Установка terraform
```shell
wget https://hashicorp-releases.yandexcloud.net/terraform/1.4.6/terraform_1.4.6_linux_amd64.zip
unzip terraform_1.4.6_linux_amd64.zip
mv terraform /usr/local/bin/
```

## Установка бота
```shell
git clone git@github.com:kignatovich/tms-dp.git
git checkout terraform_bot_bran
chmode +x ./telegram_bot/instll_bot.sh
sudo ./telegram_bot/install_bot.sh
```
После запуска данной команды, скрипт установит службу бота и запустит ее. 

После установки бота, нужно зайти в телеграмм и дать боту команду на установку инфраструктуры.
```bash
/deploy
```

В боте реализовна проерка на наличие файлов для запуска деплоя.
Файлы наличие которых проверяются: providers.tf, terraform.tfvars, variables.tf, "main.tf.


<img width="615" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/905ee2cf-06ff-4f5e-b489-e969b2e66391">
